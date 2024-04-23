-- Original Code
-- Fix or improve the name and the implementation of the below method

function do_sth_with_PlayerParty(playerId, membername)
    player = Player(playerId)
    local party = player:getParty()
    
    for k,v in pairs(party:getMembers()) do
        if v == Player(membername) then
            party:removeMember(Player(membername))
        end
    end
end

-- Modified Code

-- Name is not descriptive
-- The goal of function is to remove a member (specified by memberId) from 
-- a player's (specified by playerID) party
-- name changed "from do_sth_with_PlayerParty" to "removeMemberFromPlayerParty"

-- Removes a member from a player's party
function removeMemberFromPlayerParty(playerId, memberName)
    -- The 'membername' variable did not match the notation of the other variables provided
    -- so it was changed to follow a camel case naming style

    -- There was a concern I had about the memberName variable:
    -- The player who owns the party is referenced by their ID while the 
    -- player to be removed is referenced by their name
    -- the OpenTibia database schema does use names as an indexer
    -- so as far as I know this isnt of any technical concern
    -- but for clarity and consistency I would suggest the member be changed
    -- to be referenced by their ID instead of name

    -- only reason I chose not to make that change is the fact that if this function had already
    -- been implemented into the wider game then that change would possibly break other systems
    -- in a realistic scenario I would mention this concern to a lead or more senior developer, 
    -- while understanding its a pretty small nitpick

    -- the "player" variable did not have its scope defined
    -- so it is defaulted to global. I had no indication that
    -- the variable is defined or used elsewhere, and based on 
    -- its use here I assume that it does not require a global scope
    local player = Player(playerId)
    local party = player:getParty()

    -- The Player(MemberName) function in this loop
    -- (which i assume returns a player object from a db or other data structure)
    -- shouldnt be called in every iteration
    -- I changed it to instead save the member within a variable before the loop  
    local targetMember = Player(memberName)

    -- iterates through each member to find the specified member and remove them
    for k,v in pairs(party:getMembers()) do
        if v == targetMember then
            party:removeMember(targetMember)

            -- added a break here
            -- under normal gameplay circumstances a party
            -- should not contain the same member twice so
            -- there is no reason to continue iterating through
            -- members after the target member has been found and removed

            break
        end
    end
end

-- modified code without comments

function removeMemberFromPlayerParty(playerId, memberName)
    local player = Player(playerId)
    local party = player:getParty()
    local targetMember = Player(memberName)

    for k,v in pairs(party:getMembers()) do
        if v == targetMember then
            party:removeMember(targetMember)
            break
        end
    end
end