
-- compares two string version numbers, like those given by on_configuration_changed
-- returns <0 if oldVersion is older and >0 if newVersion is older, 0 if they're equal
function version_compare(oldVersion, newVersion)
    local old, new = {major,minor,patch}, {major,minor,patch}
    _,_,old.major,old.minor,old.patch = string.find(oldVersion,"(%d+)%.(%d+)%.(%d+)")
    _,_,new.major,new.minor,new.patch = string.find(newVersion,"(%d+)%.(%d+)%.(%d+)")
    if new.major ~= old.major then
        return old.major - new.major
    elseif new.minor ~= old.minor then
        return old.minor - new.minor
    elseif new.patch ~= old.patch then
        return old.patch - new.patch
    else
        return 0
    end
end

-- returns true if the given version is older than the version to compare it to.
-- if the version is nil, it returns false
function is_version_older_than(oldVersion, compareVersion)
    if oldVersion and compareVersion then
        return version_compare(oldVersion, compareVersion) < 0
    else
        return false
    end
end
