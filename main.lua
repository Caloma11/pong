WINDOW_WIDTH = 1024
WINDOW_HEIGHT = 576

-- 16:9 res

VIRTUAL_WIDTH = 426
VIRTUAL_HEIGHT = 240



push = require 'push'


-- Runs on start up (initializer)

function love.load()

    math.randomseed(os.time())

    love.graphics.setDefaultFilter('nearest', 'nearest')

    smallFont = love.graphics.newFont('font.ttf', 8) -- Sets Font
    scoreFont = love.graphics.newFont('font.ttf', 16)

    player1Score = 0
    player2Score = 0

    PLAYER1Y = 20
    PLAYER2Y = VIRTUAL_HEIGHT - 40

    PADDLE_SPEED = 200

    ballX = VIRTUAL_WIDTH / 2 - 2
    ballY = VIRTUAL_HEIGHT / 2 - 2

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

    -- Player 1 Movement

    if love.keyboard.isDown('w') then

        PLAYER1Y = math.max(2, PLAYER1Y - PADDLE_SPEED * dt)
    elseif love.keyboard.isDown('s') then

        PLAYER1Y = math.min(VIRTUAL_HEIGHT - 20 - 2, PLAYER1Y + PADDLE_SPEED * dt)
    end

    -- Player 2 movement

    if  love.keyboard.isDown('up') then

        PLAYER2Y = math.max(2, PLAYER2Y - PADDLE_SPEED * dt)
    elseif love.keyboard.isDown('down') then

        PLAYER2Y = math.min(VIRTUAL_HEIGHT - 20 - 2, PLAYER2Y + PADDLE_SPEED * dt)
    end

    if gameState == 'play' then -- move the ball 'randomly'
        ballX = ballX + ballDX * dt
        ballY = ballY + ballDY * dt
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

            ballX = VIRTUAL_WIDTH / 2 - 2
            ballY = VIRTUAL_HEIGHT / 2 - 2

            ballDX = math.random(2) == 1 and -100 or 100  -- Delta X
            ballDY = math.random(-50, 50) -- Delta Y
        end
    end
end



-- Called after updpate, literally draws

function love.draw()

    push:apply('start') -- Start rendering at virtual res

    love.graphics.clear(66 / 255, 39 / 255, 59 / 255, 1) -- Sets background color

    love.graphics.rectangle('fill', ballX, ballY, 4 , 4) -- Sets the 'ball' in the middle

    love.graphics.rectangle('line', 5, PLAYER1Y, 5, 20) -- Renders left paddle

    love.graphics.rectangle('line', VIRTUAL_WIDTH - 10, PLAYER2Y, 5, 20) -- Renders right paddle


    love.graphics.setFont(smallFont) -- Makes smallFont the active font

    if gameState == 'start' then
        love.graphics.printf("Hello, start!",
            0,                               -- Starting X
            10,                                -- Starting Y (VIRTUAL_HEIGHT / 2 - 6 would be center)
            VIRTUAL_WIDTH,                   -- Center reference
            'center')                        -- Aligment mode
    elseif gameState == 'play' then
            love.graphics.printf("Hello, play!",
            0,                               -- Starting X
            10,                                -- Starting Y (VIRTUAL_HEIGHT / 2 - 6 would be center)
            VIRTUAL_WIDTH,                   -- Center reference
            'center')
    end


    love.graphics.setFont(scoreFont) -- Makes scoreFont the active font
    love.graphics.print(player1Score, VIRTUAL_WIDTH / 2 - 50, VIRTUAL_HEIGHT / 3) -- Print scores
    love.graphics.print(player2Score, VIRTUAL_WIDTH / 2 + 30, VIRTUAL_HEIGHT / 3)

    push:apply('end')
end
