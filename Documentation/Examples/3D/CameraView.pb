
; ------------------------------------------------------------
;
;   PureBasic - CameraView
;
;    (c) Fantaisie Software
;
; ------------------------------------------------------------
;



Define.f KeyX, KeyY, MouseX, MouseY, SpriteX, SpriteY

InitEngine3D()

InitSprite()
InitKeyboard()
InitMouse()

ExamineDesktops():dx=DesktopWidth(0)*0.8:dy=DesktopHeight(0)*0.8
OpenWindow(0, 0,0, DesktopUnscaledX(dx),DesktopUnscaledY(dy), " CameraView - [Esc] quit",#PB_Window_ScreenCentered)
OpenWindowedScreen(WindowID(0), 0, 0, dx, dy, 0, 0, 0)

Add3DArchive(#PB_Compiler_Home + "examples/3d/Data/Textures", #PB_3DArchive_FileSystem)
Add3DArchive(#PB_Compiler_Home + "examples/3d/Data/Models", #PB_3DArchive_FileSystem)
Add3DArchive(#PB_Compiler_Home + "examples/3d/Data/Scripts", #PB_3DArchive_FileSystem)
Add3DArchive(#PB_Compiler_Home + "examples/3d/Data/Packs/Desert.zip", #PB_3DArchive_Zip)
Parse3DScripts()

;- Ground
;
CreateMaterial(0, LoadTexture(0, "Dirt.jpg"))
CreatePlane(0, 1500, 1500, 40, 40, 15, 15)
CreateEntity(0,MeshID(0),MaterialID(0))
EntityRenderMode(0, 0)

CreateCube(1, 50)
CreateEntity(1, MeshID(1), GetScriptMaterial(1, "Color/Blue"), 0, 50, 0)

;- Camera
;
CreateCamera(1, 50, 50, 1, 1) ; J'ai ajouté et caché cette caméra pour que la caméra 0 ne soit pas zoomée ! Bug ogre ?

CreateCamera(0, 25, 25, 50, 50)
MoveCamera(0, 0, 120, 500, #PB_Absolute)
CameraBackColor(0, $FF)

;- Light
;
CreateLight(0, RGB(255, 255, 255), -40, 100, 80)
AmbientColor(RGB(80, 80, 80))

;- Sprite
;
UsePNGImageDecoder()
LoadImage(0, "Data/Textures/viseur-jeux.png")
ResizeImage(0, 30 * CameraViewWidth(0) / ImageWidth(0), 30 * CameraViewWidth(0) / ImageWidth(0)); Keep Size Ratio for all resolution

CreateSprite(0, ImageWidth(0), ImageHeight(0))
If StartDrawing(SpriteOutput(0))
  DrawImage(ImageID(0), 0, 0)
  StopDrawing()
EndIf

TransparentSpriteColor(0, RGB(255, 255, 255))

SpriteX = CameraViewX(0) + (CameraViewWidth(0)  - SpriteWidth(0))  / 2
SpriteY = CameraViewY(0) + (CameraViewHeight(0) - SpriteHeight(0)) / 2

Repeat
  
  While WindowEvent():Wend
  
  If ExamineMouse()
    MouseX = -MouseDeltaX()/10
    MouseY = -MouseDeltaY()/10
  EndIf
  
  If ExamineKeyboard()    
    KeyX = (KeyboardPushed(#PB_Key_Right)-KeyboardPushed(#PB_Key_Left))*2
    Keyy = (KeyboardPushed(#PB_Key_Down)-KeyboardPushed(#PB_Key_Up))*2
  EndIf
  
  
  RotateCamera(0, MouseY, MouseX, 0, #PB_Relative)
  MoveCamera  (0, KeyX, 0, KeyY)
  
  RenderWorld()
  
  DisplayTransparentSprite(0, SpriteX, SpriteY)
  
  FlipBuffers()
Until KeyboardPushed(#PB_Key_Escape) Or Quit = 1

