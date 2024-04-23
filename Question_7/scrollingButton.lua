-- Defines the hotkey to open the window
local HOTKEY = 'Ctrl+A'

-- Degines the variable for the window
local scrollingButtonWindow = nil

-- Defines the moving button
local jumpButton = nil
-- Defines and initializes the button's position
local jumpButtonPosition = 0

-- Defines the time between button movements
local jumpButtonMoveTime = 50
-- Defines the amount of movement
local jumpButtonMoveDistance = 5

-- Defines the max width and height of the window
local jumpButtonMaxWidth = 0
local jumpButtonMaxHeight = 0

-- Defines the vertical margin for the window
-- so the button does not overlap with the top
local verticalMargin = 70

-- Defines whether or not the movement behavior is running
local isRunning = false;

-- Initializes the window
function init()
  g_ui.importStyle('scrollingButton')

  scrollingButtonWindow = g_ui.createWidget('ScrollingButtonWindow', rootWidget)
  scrollingButtonWindow:hide()

  -- finds the button element
  jumpButton = scrollingButtonWindow:getChildById('jumpButton')
  -- binds the window open to the Hotkey
  g_keyboard.bindKeyDown(HOTKEY, show)

  -- sets the height and width variables based on the window size
  jumpButtonMaxWidth = scrollingButtonWindow:getWidth() - jumpButton:getWidth() * 2
  jumpButtonMaxHeight = scrollingButtonWindow:getHeight() - verticalMargin

  resetButtonPosition()
end

-- terminates the window
function terminate()
  -- unbinds the hotkey
  g_keyboard.unbindKeyDown(HOTKEY)
  -- destroys the window
  isRunning = false
  scrollingButtonWindow:destroy()
end

-- Shots the window
function show()
  if g_game.isOnline() then
    scrollingButtonWindow:show()
    scrollingButtonWindow:focus()
    -- resets the button position
    resetButtonPosition()
    -- schedules the initial button movement event

    if (not isRunning) then
      scheduleEvent(incrementButtonPosition, jumpButtonMoveTime, nil)
    end
  end
end

-- resets the buttons position to the right of the window at a random height
function resetButtonPosition()
  -- returns if the button is null
  if(jumpButton == nil) then return end
  -- sets the top margin to a random vertical position
  jumpButton:setMarginTop(math.random(0, jumpButtonMaxHeight))
  -- sets the button's horizontal position to the right
  setButtonPosition(0)
end

-- Updates the buttons position to the provided parameter
function setButtonPosition(buttonPosition)
  -- updates the variable holding the button's position
  jumpButtonPosition = buttonPosition

  -- if the button's position is past the end of the window then reset the button and return
  if(jumpButtonPosition > jumpButtonMaxWidth) then
    resetButtonPosition()
    return
  end

  -- return if the button is null
  if(jumpButton == nil) then return end

  -- updates the button's margin to the new position
  jumpButton:setMarginRight(jumpButtonPosition)
end

-- Recursive function that increments the button position as long as the window is open
function incrementButtonPosition()
  -- returns if the window is not visible
  if not scrollingButtonWindow:isVisible() then 
    isRunning = false
    return 
  end

  -- increases the button's position
  setButtonPosition(jumpButtonPosition + jumpButtonMoveDistance)

  -- schedules an event that calls this function
  scheduleEvent(incrementButtonPosition, jumpButtonMoveTime)
  isRunning = true
end