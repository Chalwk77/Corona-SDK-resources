-- requires that the google play webstore listing description contains "Current App Version: digit(decimal)digit(decimal)digit+"

local current_build = system.getInfo("appVersionString")
local function networkListener(event)
    if (event.isError) then
        print('Network error:', event.response)
    else
        local data = event.response
        if (string.find(data, "Current App Version: %d%.%d.%d+")) then
            local replace = "Current App Version: %d%.%d.%d+"
            local google_play_version = string.gsub(string.match(data, replace), replace, string.match(string.match(data, replace), "%d%.%d.%d+"))
            local version = {current = current_build, latest_update = google_play_version}
            local height_from_bottom = -100
            if version ~= nil and version.latest_update ~= nil then
                if (string.find(version.latest_update, "%d%.%d.%d+") == 1) then
                    if (version.current == version.latest_update) then
                        application_version = display.newText( "Version " .. version.current, display.viewableContentWidth / 2, display.viewableContentHeight / 2, native.systemFontBold, 10 )
                        application_version:setFillColor(1, 0.9, 0.5)
                        application_version.x = display.contentCenterX
                        application_version.y = display.contentCenterX + display.contentCenterY - height_from_bottom
                        application_version.alpha = 0.50
                    elseif (version.current < version.latest_update) then
                        local function onTextClick( event )
                            if ( event.phase == "began" ) then
                                showDialog("Download Latest Update", "Would you like to download the latest update?", 18, true)
                            end
                            return true
                        end
                        application_version = display.newText( "Version " .. version.latest_update .. " is available!", display.viewableContentWidth / 2, display.viewableContentHeight / 2, native.systemFontBold, 10 )
                        application_version:setFillColor(1, 0.9, 0.5)
                        application_version.x = display.contentCenterX
                        application_version.y = display.contentCenterX + display.contentCenterY - height_from_bottom
                        application_version.alpha = 0.50
                        application_version:addEventListener( "touch", onTextClick )
                    end
                    print("Google Play App Version: " .. google_play_version)
                end
            end
        else
            print('Current Version could not be found!')
        end
    end
    print("Google Play App Version: " .. google_play_version)
end

function CheckForUpdates()
    local data = network.request("link to google play webstore app listing", "POST", networkListener)
end
CheckForUpdates()
