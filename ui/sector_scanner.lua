-- Sector Overview 1.0.0 standalone HUD sector activity panel

local ffi = require("ffi")
local C = ffi.C

ffi.cdef[[
    typedef struct {
        int relationStatus;
        int relationValue;
        int relationLEDValue;
        bool isBoostedValue;
        const char* owningFactionID;
    } RelationDetails2;
    uint64_t GetPlayerOccupiedShipID(void);
    float GetDistanceBetween(uint64_t component1id, uint64_t component2id);
    bool IsComponentOperational(uint64_t componentid);
    RelationDetails2 GetRelationStatus4(const uint64_t componentid, const char*const connectionname);
    bool SetSofttarget(uint64_t componentid, const char*const connectionname);
]]

local L = {
    version = "1.0.0",
    white = "\27#FFFFFFFF#",
    blueColor = { r = 27, g = 121, b = 235, a = 100 },
    whiteColor = { r = 255, g = 255, b = 255, a = 100 },
    topLevelMenu = nil,
    targetConnection = nil,
    contactCategory = "ships",
    contactFilter = "all",
    contactSort = "distance",
    contactListEnabled = true,
    contactListMasterEnabled = true,
    contactPage = 1,
    contactPageSize = 24,
    contactBuild = nil,
    contactBuildSeen = nil,
    contactBuildRescue = nil,
    contacts = {},
    rescueContactKeys = {},
    contactPanel = nil,
    topLevelMouseHandlersWrapped = false,
    contactScanRequested = false,
    contactScanInterval = 3.0,
    nextContactScan = 0,
    maxContactRows = 120,
}

local function ssText(id)
    return ReadText(987656, id)
end

local function normalizeComponent(component)
    if component == nil then
        return nil
    end
    if type(component) == "cdata" then
        return ConvertStringTo64Bit(tostring(component))
    end
    if type(component) == "number" then
        return ConvertIDTo64Bit(component)
    end
    return ConvertStringTo64Bit(tostring(component))
end

local function getTargetRelationColor(component)
    local relation = C.GetRelationStatus4(component, L.targetConnection).relationStatus
    local colornames = {
        [0] = "targetsystem_relation_hostile",
        [1] = "targetsystem_relation_enemy",
        [2] = "targetsystem_relation_neutral",
        [3] = "targetsystem_relation_friendly",
        [4] = "targetsystem_relation_member",
        [5] = "targetsystem_relation_player",
        [6] = "targetsystem_relation_neutral",
    }
    return Color[colornames[relation] or "targetsystem_relation_neutral"] or L.whiteColor
end

local function colorEscape(color)
    local function channel(value)
        return math.max(0, math.min(255, math.floor((value or 255) + 0.5)))
    end
    return string.format("\27#FF%02X%02X%02X#", channel(color.r), channel(color.g), channel(color.b))
end

local function getVisibleContacts()
    local result = {}
    local playership = C.GetPlayerOccupiedShipID()
    if playership == 0 then
        return result
    end

    for _, rawcomponent in ipairs(L.contacts) do
        local component = normalizeComponent(rawcomponent)
        if component and (component ~= 0) and (component ~= playership) then
            local success, entry = pcall(function()
                local isplayerowned, isenemy, ishostile,
                    classid, realclassid, icon, objectname, macro = GetComponentData(
                        component,
                        "isplayerowned", "isenemy", "ishostile",
                        "classid", "realclassid", "icon", "name", "macro"
                    )

                local shipclass = realclassid or classid
                local isship = Helper.isComponentClass(classid, "ship")
                local isstation = Helper.isComponentClass(shipclass, "station")
                    or Helper.isComponentClass(classid, "station")
                local ismine = Helper.isComponentClass(classid, "mine")
                    or Helper.isComponentClass(shipclass, "mine")
                local isxs = Helper.isComponentClass(shipclass, "ship_xs")

                local enemy = (isenemy == true) or (isenemy == 1)
                    or (ishostile == true) or (ishostile == 1)
                local owned = (isplayerowned == true) or (isplayerowned == 1)
                local neutral = (not owned) and (not enemy)

                local macrotext = string.lower(tostring(macro or ""))
                local icontext = string.lower(tostring(icon or ""))
                local componentkey = tostring(component)
                local isrescuepod = L.rescueContactKeys[componentkey] == true
                    or (isxs and (
                        macrotext == "ship_gen_xs_escapepod_01_a_macro"
                        or icontext == "ship_xs_escapepod_01"
                        or string.find(macrotext, "escapepod", 1, true)
                        or string.find(icontext, "escapepod", 1, true)
                    ))

                local typename = ""
                local islasertower = false
                if macro and tostring(macro) ~= "" then
                    local macrosuccess, macroname, macrolasertower = pcall(
                        GetMacroData, macro, "name", "islasertower"
                    )
                    if macrosuccess then
                        typename = tostring(macroname or "")
                        islasertower = (macrolasertower == true) or (macrolasertower == 1)
                    end
                end

                local categorymatch = false
                if L.contactCategory == "ships" then
                    categorymatch = isship and (not isxs) and (not isrescuepod) and (not islasertower)
                elseif L.contactCategory == "stations" then
                    categorymatch = isstation
                elseif L.contactCategory == "deployables" then
                    categorymatch = ismine or (islasertower and enemy)
                elseif L.contactCategory == "rescue" then
                    categorymatch = isrescuepod
                end

                local relationmatch = true
                if (L.contactCategory == "ships") or (L.contactCategory == "stations") then
                    relationmatch = (L.contactFilter == "all")
                        or ((L.contactFilter == "owned") and owned)
                        or ((L.contactFilter == "neutral") and neutral)
                        or ((L.contactFilter == "enemy") and enemy)
                end

                local operational = C.IsComponentOperational(component)
                local operationalmatch = true
                if L.contactCategory == "ships" then
                    operationalmatch = operational
                end

                if categorymatch and relationmatch and operationalmatch then
                    local displayname = tostring(objectname or "")

                    if isrescuepod then
                        local pilotsuccess, pilotname = pcall(function()
                            local pilot = GetComponentData(component, "assignedpilot")
                            if pilot then
                                local pilot64 = ConvertIDTo64Bit(pilot)
                                if pilot64 and IsValidComponent(pilot64) then
                                    return GetComponentData(pilot64, "name")
                                end
                            end
                            return nil
                        end)

                        if pilotsuccess and pilotname and (tostring(pilotname) ~= "") then
                            displayname = tostring(pilotname)
                        end
                    end

                    local size = "—"
                    local sizeorder = 0

                    if isrescuepod then
                        size = "XS"
                        sizeorder = 0
                    elseif isship then
                        size = "S"
                        sizeorder = 1
                        if Helper.isComponentClass(shipclass, "ship_xl") then
                            size = "XL"
                            sizeorder = 4
                        elseif Helper.isComponentClass(shipclass, "ship_l") then
                            size = "L"
                            sizeorder = 3
                        elseif Helper.isComponentClass(shipclass, "ship_m") then
                            size = "M"
                            sizeorder = 2
                        elseif Helper.isComponentClass(shipclass, "ship_xs") then
                            size = "XS"
                            sizeorder = 0
                        end
                    end

                    local fallbackicon = "mapob_ship_s"
                    if isstation then
                        fallbackicon = "mapob_station"
                    elseif ismine then
                        fallbackicon = "mapob_mine"
                    elseif isrescuepod then
                        fallbackicon = "ship_xs_escapepod_01"
                    end

                    if typename == "" then
                        if isstation then
                            typename = ssText(224)
                        elseif ismine then
                            typename = ssText(225)
                        elseif islasertower then
                            typename = ssText(226)
                        elseif isrescuepod then
                            typename = ssText(227)
                        end
                    end

                    return {
                        component = component,
                        name = displayname,
                        typename = typename,
                        icon = icon or fallbackicon,
                        color = getTargetRelationColor(component),
                        distance = C.GetDistanceBetween(playership, component),
                        size = size,
                        sizeorder = sizeorder,
                    }
                end
            end)
            if success and entry then
                table.insert(result, entry)
            end
        end
    end

    local function lower(value)
        return string.lower(tostring(value or ""))
    end

    table.sort(result, function(a, b)
        if L.contactSort == "size" then
            if a.sizeorder ~= b.sizeorder then
                return a.sizeorder > b.sizeorder
            end
            local aname, bname = lower(a.name), lower(b.name)
            if aname ~= bname then
                return aname < bname
            end
        elseif L.contactSort == "name" then
            local aname, bname = lower(a.name), lower(b.name)
            if aname ~= bname then
                return aname < bname
            end
        elseif L.contactSort == "type" then
            local atype, btype = lower(a.typename), lower(b.typename)
            if atype ~= btype then
                return atype < btype
            end
            local aname, bname = lower(a.name), lower(b.name)
            if aname ~= bname then
                return aname < bname
            end
        else
            if a.distance ~= b.distance then
                return a.distance < b.distance
            end
        end

        if a.distance ~= b.distance then
            return a.distance < b.distance
        end
        return tostring(a.component) < tostring(b.component)
    end)

    while #result > L.maxContactRows do
        table.remove(result)
    end
    return result
end

function L.SetContactCategory(category)
    L.contactCategory = category
    L.contactPage = 1
    if L.topLevelMenu then
        L.topLevelMenu.requestUpdate(0)
    end
end

function L.SetContactFilter(filter)
    L.contactFilter = filter
    L.contactPage = 1
    if L.topLevelMenu then
        L.topLevelMenu.requestUpdate(0)
    end
end

function L.SetContactSort(sortmode)
    L.contactSort = sortmode
    L.contactPage = 1
    if L.topLevelMenu then
        L.topLevelMenu.requestUpdate(0)
    end
end

function L.SetContactListMasterEnabled(_, enabled)
    local newstate = (enabled == true) or (enabled == 1)
    if L.contactListMasterEnabled == newstate then
        return
    end

    L.contactListMasterEnabled = newstate
    if newstate then
        L.nextContactScan = 0
    else
        L.contacts = {}
        L.rescueContactKeys = {}
        L.contactBuild = nil
        L.contactBuildSeen = nil
        L.contactBuildRescue = nil
        L.contactScanRequested = false
    end

    if L.topLevelMenu then
        L.topLevelMenu.requestUpdate(0)
    end
end

function L.ToggleContactList()
    L.contactListEnabled = not L.contactListEnabled
    if L.contactListEnabled then
        L.nextContactScan = 0
    end
    if L.topLevelMenu then
        L.topLevelMenu.requestUpdate(0)
    end
end

function L.ChangeContactPage(change)
    L.contactPage = L.contactPage + change
    if L.topLevelMenu then
        L.topLevelMenu.requestUpdate(0)
    end
end

local function formatDistance(distance)
    if distance >= 1000000 then
        return string.format("%.1f Mm", distance / 1000000)
    elseif distance >= 1000 then
        return string.format("%.1f km", distance / 1000)
    end
    return string.format("%.0f m", distance)
end

local function targetContact(component)
    if C.SetSofttarget(component, "") then
        PlaySound("ui_target_set")
    else
        PlaySound("ui_target_set_fail")
    end
end

local function addContactList(frame, tables)
    local contacts = getVisibleContacts()
    local panelborder = frame:addFrameBorder("sector_scanner_contacts", {
        color = L.blueColor,
        linewidth = 1,
        offset = 1,
    })
    local panel = frame:addTable(12, {
        x = 12,
        y = Helper.viewHeight * 0.09,
        width = math.min(390, Helper.viewWidth * 0.25),
        maxVisibleHeight = Helper.viewHeight * 0.57,
        tabOrder = 1,
        borderEnabled = false,
        highlightMode = "off",
        reserveScrollBar = false,
        backgroundID = "solid",
        backgroundColor = { r = 0, g = 0, b = 0, a = 70, glow = 0 },
        backgroundPadding = 1,
        frameborder = panelborder.id,
    })
    L.contactPanel = panel

    -- Five semantic data columns are distributed over twelve layout columns:
    -- icon | size | name | type | distance.
    local widths = { 5, 7, 8, 8, 8, 7, 8, 8, 8, 8, 13, 12 }
    for column = 1, 12 do
        panel:setColWidthPercent(column, widths[column])
    end

    local togglerow = panel:addRow(true, { fixed = true, borderBelow = true })
    local togglebutton = togglerow[1]:setColSpan(12):createButton({
        height = 21,
        bgColor = L.contactListEnabled and { r = 12, g = 55, b = 92, a = 72, glow = 0 }
            or Color["button_background_hidden"],
        highlightColor = Color["button_highlight_default"],
        borderColor = Color["button_border_hidden"],
    }):setText(L.contactListEnabled and (ssText(200) .. ": " .. ssText(201)) or (ssText(200) .. ": " .. ssText(202)), {
        fontsize = 9,
        halign = "center",
        color = L.whiteColor,
    })
    togglebutton.handlers.onClick = L.ToggleContactList

    if not L.contactListEnabled then
        table.insert(tables, panel)
        return
    end

    local categorylabelrow = panel:addRow(false, { fixed = true, borderBelow = false })
    categorylabelrow[1]:setColSpan(12):createText(ssText(203), {
        fontsize = 8,
        halign = "left",
        color = { r = 185, g = 205, b = 220, a = 80, glow = 0 },
        x = 4,
    })

    local categories = {
        { id = "ships", text = ssText(204) },
        { id = "stations", text = ssText(205) },
        { id = "deployables", text = ssText(206) },
        { id = "rescue", text = ssText(207) },
    }
    local categoryrow = panel:addRow(true, { fixed = true, borderBelow = false })
    for index, category in ipairs(categories) do
        local categoryid = category.id
        local selected = L.contactCategory == categoryid
        local firstcolumn = ((index - 1) * 3) + 1
        local button = categoryrow[firstcolumn]:setColSpan(3):createButton({
            height = 20,
            bgColor = selected and { r = 12, g = 55, b = 92, a = 72, glow = 0 }
                or Color["button_background_hidden"],
            highlightColor = Color["button_highlight_default"],
            borderColor = Color["button_border_hidden"],
        }):setText(category.text, {
            fontsize = 8,
            halign = "center",
            color = L.whiteColor,
        })
        button.handlers.onClick = function()
            L.SetContactCategory(categoryid)
        end
    end

    if (L.contactCategory == "ships") or (L.contactCategory == "stations") then
        local relationlabelrow = panel:addRow(false, { fixed = true, borderBelow = false })
        relationlabelrow[1]:setColSpan(12):createText(ssText(208), {
            fontsize = 8,
            halign = "left",
            color = { r = 185, g = 205, b = 220, a = 80, glow = 0 },
            x = 4,
        })

        local filters = {
            { id = "all", text = ssText(209) },
            { id = "owned", text = ssText(210) },
            { id = "neutral", text = ssText(211) },
            { id = "enemy", text = ssText(212) },
        }
        local filterrow = panel:addRow(true, { fixed = true, borderBelow = false })
        for index, filter in ipairs(filters) do
            local filterid = filter.id
            local selected = L.contactFilter == filterid
            local firstcolumn = ((index - 1) * 3) + 1
            local button = filterrow[firstcolumn]:setColSpan(3):createButton({
                height = 20,
                bgColor = selected and { r = 12, g = 55, b = 92, a = 72, glow = 0 }
                    or Color["button_background_hidden"],
                highlightColor = Color["button_highlight_default"],
                borderColor = Color["button_border_hidden"],
            }):setText(filter.text, {
                fontsize = 8,
                halign = "center",
                color = L.whiteColor,
            })
            button.handlers.onClick = function()
                L.SetContactFilter(filterid)
            end
        end
    end

    local sortlabelrow = panel:addRow(false, { fixed = true, borderBelow = false })
    sortlabelrow[1]:setColSpan(12):createText(ssText(213), {
        fontsize = 8,
        halign = "left",
        color = { r = 185, g = 205, b = 220, a = 80, glow = 0 },
        x = 4,
    })

    local sortrow = panel:addRow(true, { fixed = true, borderBelow = true })
    local sorts = {
        { id = "size", text = ssText(214) },
        { id = "name", text = ssText(215) },
        { id = "type", text = ssText(216) },
        { id = "distance", text = ssText(217) },
    }
    for index, sortmode in ipairs(sorts) do
        local sortid = sortmode.id
        local selected = L.contactSort == sortid
        local firstcolumn = ((index - 1) * 3) + 1
        local button = sortrow[firstcolumn]:setColSpan(3):createButton({
            height = 18,
            bgColor = selected and { r = 12, g = 55, b = 92, a = 60, glow = 0 }
                or Color["button_background_hidden"],
            highlightColor = Color["button_highlight_default"],
            borderColor = Color["button_border_hidden"],
        }):setText(sortmode.text, {
            fontsize = 8,
            halign = "center",
            color = L.whiteColor,
        })
        button.handlers.onClick = function()
            L.SetContactSort(sortid)
        end
    end

    local pagecount = math.max(1, math.ceil(#contacts / L.contactPageSize))
    L.contactPage = math.max(1, math.min(L.contactPage, pagecount))
    local firstcontact = ((L.contactPage - 1) * L.contactPageSize) + 1
    local lastcontact = math.min(#contacts, firstcontact + L.contactPageSize - 1)

    local currenttarget = normalizeComponent(GetPlayerTarget())
    if #contacts == 0 then
        local emptytext = ssText(218)
        if L.contactCategory == "stations" then
            emptytext = ssText(219)
        elseif L.contactCategory == "deployables" then
            emptytext = ssText(220)
        elseif L.contactCategory == "rescue" then
            emptytext = ssText(221)
        end

        local row = panel:addRow(false, { borderBelow = false })
        row[1]:setColSpan(12):createText(emptytext, {
            fontsize = 9,
            halign = "left",
            color = { r = 180, g = 190, b = 200, a = 75, glow = 0 },
            x = 5,
        })
    else
        for index = firstcontact, lastcontact do
            local contact = contacts[index]
            local selected = currenttarget and (tostring(currenttarget) == tostring(contact.component))
            local row = panel:addRow(true, { borderBelow = false })
            local buttonproperties = {
                height = 19,
                bgColor = selected and { r = 20, g = 70, b = 100, a = 62, glow = 0 }
                    or Color["button_background_hidden"],
                highlightColor = Color["button_background_hidden"],
                borderColor = Color["button_border_hidden"],
                mouseOverText = contact.name,
            }

            local iconbutton = row[1]:createButton(buttonproperties):setText(
                colorEscape(contact.color) .. "\27[" .. contact.icon .. "]" .. L.white, {
                    fontsize = 8,
                    halign = "center",
                    color = L.whiteColor,
                }
            )
            local sizebutton = row[2]:createButton(buttonproperties):setText(contact.size, {
                fontsize = 8,
                halign = "center",
                color = L.whiteColor,
            })
            local namebutton = row[3]:setColSpan(4):createButton(buttonproperties):setText(contact.name, {
                fontsize = 8,
                halign = "left",
                color = L.whiteColor,
                x = 2,
            })
            local typebutton = row[7]:setColSpan(4):createButton(buttonproperties):setText(contact.typename, {
                fontsize = 8,
                halign = "left",
                color = L.whiteColor,
                x = 2,
            })
            local distancebutton = row[11]:setColSpan(2):createButton(buttonproperties):setText(
                formatDistance(contact.distance), {
                    fontsize = 8,
                    halign = "right",
                    color = L.whiteColor,
                    x = 2,
                }
            )

            local component = contact.component
            local function selectcontact()
                targetContact(component)
            end
            iconbutton.handlers.onClick = selectcontact
            sizebutton.handlers.onClick = selectcontact
            namebutton.handlers.onClick = selectcontact
            typebutton.handlers.onClick = selectcontact
            distancebutton.handlers.onClick = selectcontact
        end
    end

    local pagerow = panel:addRow(true, { fixed = true, borderBelow = false })
    local upbutton = pagerow[1]:setColSpan(4):createButton({
        height = 20,
        active = L.contactPage > 1,
        bgColor = Color["button_background_hidden"],
        highlightColor = Color["button_highlight_default"],
        borderColor = Color["button_border_hidden"],
    }):setText(ssText(222), { fontsize = 8, halign = "center", color = L.whiteColor })
    upbutton.handlers.onClick = function()
        L.ChangeContactPage(-1)
    end
    pagerow[5]:setColSpan(4):createText(
        tostring(L.contactPage) .. " / " .. tostring(pagecount), {
            fontsize = 8,
            halign = "center",
            color = { r = 185, g = 205, b = 220, a = 80, glow = 0 },
        }
    )
    local downbutton = pagerow[9]:setColSpan(4):createButton({
        height = 20,
        active = L.contactPage < pagecount,
        bgColor = Color["button_background_hidden"],
        highlightColor = Color["button_highlight_default"],
        borderColor = Color["button_border_hidden"],
    }):setText(ssText(223), { fontsize = 8, halign = "center", color = L.whiteColor })
    downbutton.handlers.onClick = function()
        L.ChangeContactPage(1)
    end

    table.insert(tables, panel)
end

function L.UIXShouldShowHUD()
    return C.GetPlayerOccupiedShipID() ~= 0
end

function L.UIXAddHUDTables(frame)
    local tables = {}
    L.contactPanel = nil

    if L.contactListMasterEnabled then
        addContactList(frame, tables)
    end

    return tables
end

function L.UIXOnUpdate(curtime)
    if L.contactListMasterEnabled
            and L.contactListEnabled
            and (curtime >= L.nextContactScan)
            and (not L.contactScanRequested) then
        L.contactScanRequested = true
        L.nextContactScan = curtime + L.contactScanInterval
        AddUITriggeredEvent("SectorScanner", "contacts_request")
    end
end

function L.ContactScanStart(_, expectedcount)
    L.contactBuild = {}
    L.contactBuildSeen = {}
    L.contactBuildRescue = {}
end

local function addContactBuildItem(component, isrescue)
    if L.contactBuild then
        local normalized = normalizeComponent(component)
        local key = tostring(normalized or component)
        if isrescue then
            L.contactBuildRescue[key] = true
        end
        if not L.contactBuildSeen[key] then
            L.contactBuildSeen[key] = true
            table.insert(L.contactBuild, component)
        end
    end
end

function L.ContactScanItem(_, component)
    addContactBuildItem(component, false)
end

function L.ContactScanRescueItem(_, component)
    addContactBuildItem(component, true)
end

function L.ContactScanRescueCount(_, count)
    -- Count event intentionally retained for parity with the existing scan bridge.
end

function L.ContactScanEnd(_, expectedcount)
    if L.contactBuild then
        L.contacts = L.contactBuild
        L.rescueContactKeys = L.contactBuildRescue or {}
        L.contactBuild = nil
        L.contactBuildSeen = nil
        L.contactBuildRescue = nil
        L.contactScanRequested = false

        if L.topLevelMenu then
            L.topLevelMenu.requestUpdate(0)
        end
    else
        L.contactScanRequested = false
    end
end

local function isContactPanelTable(uitable)
    return L.contactPanel
        and L.contactPanel.id
        and (tostring(uitable) == tostring(L.contactPanel.id))
end

local function protectContactPanelFromTopLevelHoverRefresh()
    if L.topLevelMouseHandlersWrapped then
        return
    end
    if not L.topLevelMenu then
        return
    end

    local originalMouseOver = L.topLevelMenu.onTableMouseOver
    local originalMouseOut = L.topLevelMenu.onTableMouseOut
    if (not originalMouseOver) or (not originalMouseOut) then
        return
    end

    L.topLevelMenu.onTableMouseOver = function(uitable, row)
        if isContactPanelTable(uitable) then
            return
        end
        return originalMouseOver(uitable, row)
    end

    L.topLevelMenu.onTableMouseOut = function(uitable, row)
        if isContactPanelTable(uitable) then
            return
        end
        return originalMouseOut(uitable, row)
    end

    L.topLevelMouseHandlersWrapped = true
end

local function initUIXOverlay()
    if (not Helper) or (not Helper.getMenu) then
        error("Sector Overview HUD: UI Extensions Helper is unavailable")
    end

    L.topLevelMenu = Helper.getMenu("TopLevelMenu")
    if (not L.topLevelMenu) or (not L.topLevelMenu.registerCallback) then
        error("Sector Overview HUD: UI Extensions TopLevelMenu callbacks are unavailable")
    end

    protectContactPanelFromTopLevelHoverRefresh()
    L.targetConnection = Helper.ffiNewString("connectionui")

    L.topLevelMenu.registerCallback(
        "kHUD_get_is_show_custom_hud",
        L.UIXShouldShowHUD,
        "sector_scanner"
    )
    L.topLevelMenu.registerCallback(
        "kHUD_add_tables",
        L.UIXAddHUDTables,
        "sector_scanner"
    )
    L.topLevelMenu.registerCallback(
        "onUpdate_start",
        L.UIXOnUpdate,
        "sector_scanner"
    )

    RegisterEvent("SectorScanner.Contacts.Start", L.ContactScanStart)
    RegisterEvent("SectorScanner.Contacts.Item", L.ContactScanItem)
    RegisterEvent("SectorScanner.Contacts.RescueItem", L.ContactScanRescueItem)
    RegisterEvent("SectorScanner.Contacts.RescueCount", L.ContactScanRescueCount)
    RegisterEvent("SectorScanner.Contacts.End", L.ContactScanEnd)
    RegisterEvent("SectorScanner.Settings.ContactList", L.SetContactListMasterEnabled)

    AddUITriggeredEvent("SectorScanner", "settings_request")
end

function L.Init()
    initUIXOverlay()
end

Register_Require_With_Init(
    "extensions.sectorscanner.ui.sector_scanner",
    L,
    L.Init
)

return L
