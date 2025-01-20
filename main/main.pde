import processing.sound.*; //<>//
import g4p_controls.*;
import java.awt.Font;

// Asset variables
PImage backgroundImg, groundImg, obstacleImage, titleImage;
PImage idleSpritesheet, walkSpritesheet, jumpSpritesheet;
SoundFile bgm, jumpSound, fallSound, footstepSound, buttonClickSound;

// Animation variables
int idleFrame = 0, walkFrame = 0, jumpFrame = 0;
int frameDelay = 6;
int frameCounter = 0;
int idleFrameWidth = 672 / 7;
int walkFrameWidth = 768 / 8;
int jumpFrameWidth = 480 / 5;
int frameHeight = 84;
String currentState = "idle";

// Character variables
float charX = 100, charY = 410;
float charSpeedY = 0;
float charSpeedX = 0;
boolean isJumping = false;
boolean isFacingLeft = false;

// Character dimensions (actual visible sprite)
int charVisibleWidth = 45;
int charVisibleHeight = 70;

// Collision offset values
int collisionOffsetX = 15;
int collisionOffsetY = 10;
int collisionWidth = charVisibleWidth - (collisionOffsetX * 2);
int collisionHeight = charVisibleHeight - (collisionOffsetY * 2);

// Game state variables
int currentScreen = 0;
int groundHeight = 150;
boolean isPaused = false;
boolean isGameOver = false;
boolean levelCompleted = false;

// Level data
int[][] obstaclesLevel1 = {{300, 450}, {500, 450}, {700, 450}};
int[][] gapsLevel1 = {{400, 500}};
int[][] obstaclesLevel2 = {{200, 450}, {400, 450}, {540, 450}};
int[][] gapsLevel2 = {{300, 400}, {600, 700}};

// GUI Buttons
GButton btnPlay, btnAbout, btnQuit, btnCredit;
GButton btnResume, btnRestart, btnExitToMenu;
GButton btnBack;

// UI Colors
color primaryColor;
color secondaryColor;
color textColor;
color panelColor;

public void setup() {
  size(800, 600, JAVA2D);
  
  // Initialize colors
  primaryColor = color(139, 195, 74);    // Lime green
  secondaryColor = color(104, 159, 56);  // Darker green
  textColor = color(255, 255, 255, 230); // Slightly transparent white
  panelColor = color(48, 48, 48, 200);   // Semi-transparent dark grey
  
  loadAssets();
  createGUI();
  resetGame();
  
  if (bgm != null) {
    bgm.loop();
  }
}
