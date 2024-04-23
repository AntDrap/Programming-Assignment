// Original Code
// Assume all method calls work fine. Fix the memory leak issue in below method

void Game::addItemToPlayer(const std::string& recipient, uint16_t itemId)
{
    Player* player = g_game.getPlayerByName(recipient);
    if (!player) {
        player = new Player(nullptr);

        if (!IOLoginData::loadPlayerByName(player, recipient)) {
            return;
        }
    }

    Item* item = Item::CreateItem(itemId);
    
    if (!item) {
        return;
    }

    g_game.internalAddItem(player->getInbox(), item, INDEX_WHEREEVER, FLAG_NOLIMIT);

    if (player->isOffline()) {
        IOLoginData::savePlayer(player);
    }
}

// Modified Code

void Game::addItemToPlayer(const std::string& recipient, uint16_t itemId)
{
    // Flag to check if a new player object was created
    bool newPlayerCreated = false;

    Player* player = g_game.getPlayerByName(recipient);
    if (!player) {
        // This is where the memory leak stems from
        // a new player object is created but never disposed of
        player = new Player(nullptr);
        // sets the new player flag as true
        newPlayerCreated = true;

        if (!IOLoginData::loadPlayerByName(player, recipient)) {
            // This is the first location where a memory leak might arise
            // In the line above a new player object is created and its location
            // in memory is assigned to the player pointer, but in this fail case
            // the memory is never deallocated
            delete player;

            return;
        }
    }

    Item* item = Item::CreateItem(itemId);
    
    if (!item) {
        if(newPlayerCreated)
        {
            // This is the second location where a memory leak might arise
            // In this fail case the player object is fully assigned but the
            // system fails to locate an item
            delete player;
        }

        return;
    }

    g_game.internalAddItem(player->getInbox(), item, INDEX_WHEREEVER, FLAG_NOLIMIT);

    if (player->isOffline()) {
        IOLoginData::savePlayer(player);
    }

    if(newPlayerCreated)
    {
        // This is the final location where a memory leak might arise
        // this is just a final clean up to make sure no unmanaged memory is left behind
        delete player;
    }
}

// Modified Code without comments

void Game::addItemToPlayer(const std::string& recipient, uint16_t itemId)
{
    bool newPlayerCreated = false;

    Player* player = g_game.getPlayerByName(recipient);
    if (!player) {
        player = new Player(nullptr);
        newPlayerCreated = true;

        if (!IOLoginData::loadPlayerByName(player, recipient)) {
            delete player;

            return;
        }
    }

    Item* item = Item::CreateItem(itemId);
    
    if (!item) {
        if(newPlayerCreated)
        {
            delete player;
        }

        return;
    }

    g_game.internalAddItem(player->getInbox(), item, INDEX_WHEREEVER, FLAG_NOLIMIT);

    if (player->isOffline()) {
        IOLoginData::savePlayer(player);
    }

    if(newPlayerCreated)
    {
        delete player;
    }
}