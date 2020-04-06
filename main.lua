WINDOW_WIDTH = 1024
WINDOW_HEIGHT = 576

-- 16:9 res

VIRTUAL_WIDTH = 426
VIRTUAL_HEIGHT = 240


Class = require 'class' -- https://github.com/vrld/hump/blob/master/class.lua
push = require 'push' -- https://github.com/Ulydev/push

require 'Paddle'
require 'Ball'

-- Runs on start up (initializer)

function love.load()

    love.window.setTitle('Pong')

    math.randomseed(os.time())

    love.graphics.setDefaultFilter('nearest', 'nearest')



    smallFont = love.graphics.newFont('font.ttf', 8) -- Sets Font
    scoreFont = love.graphics.newFont('font.ttf', 16) -- https://www.dafont.com/press-start-2p.font

    player1Score = 0
    player2Score = 0

    paddle1 = Paddle(5, 20, 5, 20)
    paddle2 = Paddle(VIRTUAL_WIDTH - 10, VIRTUAL_HEIGHT - 40, 5, 20)

    ball = Ball(VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2, 4, 4)

    PADDLE_SPEED = 200

    ball:reset()

    ballDX = math.random(2) == 1 and -100 or 100  -- Delta X
    ballDY = math.random(-50, 50) -- Delta Y

    gameState = 'start'

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, { -- Initialize window with virtual res
        fullscreen = false ,
        vsync = true,
        resizable = false
    })
    -- love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, {
    --     fullscreen = false ,
    --     vsync = true,
    --     resizable = false
    -- })
end


function love.update(dt) -- dt is delta time
    if gameState == 'play' then
        if ball:collides(paddle1) then
            -- deflect ball to the right
            colided1 = true
            ball.dx = -ball.dx
        else
            colided1 = false
        end

        if ball:collides(paddle2) then
            -- deflect ball to the lefts
            ball.dx = -ball.dx
            colided2 = true
        else
            colided2 = false
        end

        if ball.y <= 0 then
            ball.dy = -ball.dy -- deflects ball down if hits upper wall
            ball.y = 2
        end

        if ball.y >= VIRTUAL_HEIGHT - 4 then
            ball.dy = -ball.dy -- deflects ball up if hits lower wall
            ball.y = VIRTUAL_HEIGHT - 6
        end


            ball:update(dt)  -- move the ball 'randomly'


        paddle1:update(dt)
        paddle2:update(dt)

        -- Player 1 Movement
        if love.keyboard.isDown('w') then
            paddle1.dy = -PADDLE_SPEED
        elseif love.keyboard.isDown('s') then
            paddle1.dy = PADDLE_SPEED
        else
            paddle1.dy = 0
        end

        -- Player 2 movement

        if  love.keyboard.isDown('up') then
            paddle2.dy = -PADDLE_SPEED
        elseif love.keyboard.isDown('down') then
            paddle2.dy = PADDLE_SPEED
        else
            paddle2.dy = 0
        end

    end
end


function love.keypressed(key) -- Called on each frame
    if key == 'escape' then

        love.event.quit()
    elseif key == 'enter' or key == 'return' then -- waits for enter to  serve
        if gameState == 'start' then
            gameState = 'play'
        elseif gameState == 'play' then
            gameState = 'start'
            ball:reset()
        end
    end
end


-- Called after updpate, literally draws

function love.draw()

    push:apply('start') -- Start rendering at virtual res

    love.graphics.clear(66 / 255, 39 / 255, 59 / 255, 1) -- Sets background color

    love.graphics.setColor(225 / 255, 242 / 255, 254 / 255, 0.4)
    love.graphics.setFont(smallFont) -- Makes smallFont the active font


    if gameState == 'start' then
        love.graphics.printf("Press enter to start!",
            0,                               -- Starting X
            10,                                -- Starting Y (VIRTUAL_HEIGHT / 2 - 6 would be center)
            VIRTUAL_WIDTH,                   -- Center reference
            'center')                        -- Aligment mode
    end

    love.graphics.setColor(255 / 255, 225 / 255, 198 / 255, 1)
    love.graphics.setFont(scoreFont) -- Makes scoreFont the active font
    love.graphics.print(player1Score, VIRTUAL_WIDTH / 2 - 50, VIRTUAL_HEIGHT / 3) -- Print scores
    love.graphics.print(player2Score, VIRTUAL_WIDTH / 2 + 30, VIRTUAL_HEIGHT / 3)

    -- if colided1  == true then
        paddle1:renderFilled()
    -- else
        -- paddle1:render()
    -- end

    -- if colided2  == true then
        paddle2:renderFilled()
    -- else
        -- paddle2:render()
    -- end

    ball:render(VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2, 5, 5)


    displayFPS()

    push:apply('end')
end

function displayFPS()
    love.graphics.setColor(4 / 255, 167 / 255, 119 / 255, 1)
    love.graphics.setFont(smallFont)
    love.graphics.print("FPS: " .. tostring(love.timer.getFPS()), 10, 5)
    love.graphics.setColor(1, 1, 1, 1)
end
