-- Original Code
-- Fix or improve the implementation of the below method

function printSmallGuildNames(memberCount)
    -- this method is supposed to print names of all guilds that have less than memberCount max members
    local selectGuildQuery = "SELECT name FROM guilds WHERE max_members < %d;"
    local resultId = db.storeQuery(string.format(selectGuildQuery, memberCount))
    local guildName = result.getString("name")
    print(guildName)
end

-- Modified Code

function printSmallGuildNames(memberCount)
    -- this method is supposed to print names of all guilds that have less than memberCount max members
    local selectGuildQuery = "SELECT name FROM guilds WHERE max_members < %d;"
    local resultId = db.storeQuery(string.format(selectGuildQuery, memberCount))

    -- the method requires a fail case in the event an error arises with the query
    if resultId == false then
        -- clears the result and returns
        result.free(resultId)
        return
    end

    -- simply printing the result will only print the first entry
    -- we need to iterate through all returned values to ensure they are displayed
    repeat
        -- The result.getString function requires another parameter
        -- this parameter references the previous query ID
        local guildName = result.getString(resultId, "name")
        print(guildName);
    until not result.next(resultId)

    -- the result needs to be cleared after being used
    result.free(resultId)
end

-- modified code without comments

function printSmallGuildNames(memberCount)
    local selectGuildQuery = "SELECT name FROM guilds WHERE max_members < %d;"
    local resultId = db.storeQuery(string.format(selectGuildQuery, memberCount))

    if resultId == false then
        result.free(resultId)
        return
    end

    repeat
        local guildName = result.getString(resultId, "name")
        print(guildName);
    until not result.next(resultId)
    
    result.free(resultId)
end