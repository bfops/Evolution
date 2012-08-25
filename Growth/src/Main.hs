-- | Main module, entry point
module Main (main) where

import Prelude ()
import Util.Prelewd

import Control.Concurrent
import Data.Tuple.Curry

import Game.Render
import Game.State
import Game.Update
import Util.Impure
import Util.IO

import Wrappers.Events
import Wrappers.OpenGL as OGL hiding (windowPos)
import qualified Graphics.UI.GLFW as GLFW

import Config

initOpenGL :: IO ()
initOpenGL = do
            shadeModel $= Smooth
            clearDepth $= 1
            depthFunc $= Just Less
            hint PerspectiveCorrection $= Nicest

drawFrame :: State -- ^ State to draw
          -> IO ()
drawFrame s = do
        -- Clear the screen
        clear [ ColorBuffer, DepthBuffer ]
        -- Reset the view
        loadIdentity

        -- Move to the render location
        translate $ Vector3 0 0 (negate $ fromIntegral viewDist :: GLdouble)

        draw s

        -- Write it all to the buffer
        flush

-- | Resize OpenGL view
resize :: Size -> IO ()
resize s@(Size w h) = do
    viewport $= (Position 0 0, s)

    matrixMode $= Projection
    loadIdentity
    perspective 45 (on (/) realToFrac w h) 0.1 64

    matrixMode $= Modelview 0
    loadIdentity

-- | Is the window open?
isOpen :: EventPoller -> IO Bool
isOpen poll = null <$> poll [CloseEvents]

-- | Take care of all received resize events
handleResize :: EventPoller -> IO ()
handleResize poll = poll [ResizeEvents] >>= maybe (return ()) resize' . last
    where
        resize' :: Event -> IO ()
        resize' (ResizeEvent s) = resize s
        resize' _ = error "poll [ResizeEvents] returned an invalid list."

mainLoop :: EventPoller -> State -> IO ()
mainLoop poll s0 = isOpen poll >>= bool (return ()) runLoop
    where
        runLoop =   visualize
                >>  update s0
                <$  threadDelay 100000
                >>= mainLoop poll

        visualize = do
            -- Since we're drawing, all the window refresh events are taken care of
            _ <- poll [RefreshEvents]
            handleResize poll
            drawFrame s0
            -- Double buffering
            GLFW.swapBuffers

-- | Run the program
main :: IO ()
main = do
        True <- GLFW.initialize
        True <- GLFW.openWindow (uncurryN Size windowSize) [] GLFW.Window

        GLFW.windowPos $= Position 0 0
        GLFW.windowTitle $= title

        initOpenGL
        let glColor = uncurryN Color4 bgColor
        clearColor $= toGLColor (glColor :: Color4 GLubyte)

        poll <- createEventPoller

        mainLoop poll initState

        GLFW.closeWindow
        GLFW.terminate
