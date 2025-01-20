
void updateCharacterPosition() {
  float prevX = charX;
  float prevY = charY;
  
  charSpeedY += 0.5;
  charY += charSpeedY;
  charX += charSpeedX;
  
  // Ground collision
  if (charY > height - groundHeight - 50) {
    charY = height - groundHeight - 50;
    charSpeedY = 0;
    isJumping = false;
    if (currentState.equals("jump")) {
      currentState = "idle";
    }
  }
}

void checkObstacleCollisions(int[][] obstacles) {
  for (int[] obs : obstacles) {
    float obstacleX = obs[0];
    float obstacleY = obs[1] - 64;
    float obstacleWidth = 64;
    float obstacleHeight = 64;
    
    if (checkCollision(charX, charY, charVisibleWidth, charVisibleHeight,
                      obstacleX, obstacleY, obstacleWidth, obstacleHeight)) {
      handleObstacleCollision(obstacleX, obstacleY, obstacleWidth, obstacleHeight);
    }
  }
}

void checkGapCollisions(int[][] gaps) {
  for (int[] gap : gaps) {
    if (charX + 40 > gap[0] && charX < gap[1] && charY + 50 >= height - groundHeight) {
      handleCollision();
    }
  }
}

void drawPauseMenu() {
  // Draw semi-transparent overlay
  fill(0, 0, 0, 180);
  rect(0, 0, width, height);
  
  // Draw pause menu panel
  float panelWidth = 400;
  float panelHeight = 300;
  float panelX = width/2 - panelWidth/2;
  float panelY = height/2 - panelHeight/2;
  
  // Panel background
  fill(panelColor);
  stroke(primaryColor);
  strokeWeight(3);
  rect(panelX, panelY, panelWidth, panelHeight, 15);
  
  // Title text
  fill(primaryColor);
  textAlign(CENTER);
  textSize(32);
  text("PAUSED", width/2, panelY + 60);
  
  showPauseMenuButtons();
}

void drawGameOver() {
  // Draw semi-transparent overlay
  fill(0, 0, 0, 180);
  rect(0, 0, width, height);
  
  // Draw game over panel
  float panelWidth = 400;
  float panelHeight = 300;
  float panelX = width/2 - panelWidth/2;
  float panelY = height/2 - panelHeight/2;
  
  // Panel background
  fill(panelColor);
  stroke(primaryColor);
  strokeWeight(3);
  rect(panelX, panelY, panelWidth, panelHeight, 15);
  
  // Title text
  fill(primaryColor);
  textAlign(CENTER);
  textSize(32);
  text("GAME OVER", width/2, panelY + 60);
  
  btnRestart.setVisible(true);
  btnExitToMenu.setVisible(true);
}

void drawAboutScreen() {
  background(backgroundImg);
  
  // Draw semi-transparent overlay
  fill(0, 0, 0, 150);
  rect(0, 0, width, height);
  
  // Draw about panel
  float panelWidth = 500;
  float panelHeight = 300;
  float panelX = width/2 - panelWidth/2;
  float panelY = height/2 - panelHeight/2;
  
  // Panel background
  fill(panelColor);
  stroke(primaryColor);
  strokeWeight(3);
  rect(panelX, panelY, panelWidth, panelHeight, 15);
  
  // Title text
  fill(primaryColor);
  textAlign(CENTER);
  textSize(32);
  text("About Game", width/2, panelY + 60);
  
  // Body text
  fill(textColor);
  textSize(16);
  text("Petualangan Si Agus adalah game platformer sederhana\n" +
       "dimana pemain harus menyelesaikan rintangan\n" +
       "untuk mencapai akhir level.", width/2, panelY + 150);
  
  btnBack.setVisible(true);
}

void drawCreditsScreen() {
  background(backgroundImg);
  
  // Draw semi-transparent overlay
  fill(0, 0, 0, 150);
  rect(0, 0, width, height);
  
  // Draw credits panel
  float panelWidth = 500;
  float panelHeight = 300;
  float panelX = width/2 - panelWidth/2;
  float panelY = height/2 - panelHeight/2;
  
  // Panel background
  fill(panelColor);
  stroke(primaryColor);
  strokeWeight(3);
  rect(panelX, panelY, panelWidth, panelHeight, 15);
  
  // Title text
  fill(primaryColor);
  textAlign(CENTER);
  textSize(32);
  text("Credits", width/2, panelY + 60);
  
  // Credits text
  fill(textColor);
  textSize(16);
  text("Developed by: [Kelompok 2]\n" +
       "Special thanks to: [Bayu Setiaji, M.Kom]", width/2, panelY + 150);
  
  btnBack.setVisible(true);
}

void animateCharacter() {
  pushMatrix();
  if (isFacingLeft) {
    translate(charX + charVisibleWidth, charY);
    scale(-1, 1);
    translate(-charX, -charY);
  }
  
  switch(currentState) {
    case "idle":
      image(idleSpritesheet, 
            charX - (idleFrameWidth - charVisibleWidth)/2, 
            charY - (frameHeight - charVisibleHeight)/2, 
            idleFrameWidth, frameHeight, 
            idleFrame * idleFrameWidth, 0, 
            (idleFrame + 1) * idleFrameWidth, frameHeight);
      if (frameCounter % frameDelay == 0) {
        idleFrame = (idleFrame + 1) % 7;
      }
      break;
    case "walk":
      image(walkSpritesheet, 
            charX - (walkFrameWidth - charVisibleWidth)/2, 
            charY - (frameHeight - charVisibleHeight)/2, 
            walkFrameWidth, frameHeight, 
            walkFrame * walkFrameWidth, 0, 
            (walkFrame + 1) * walkFrameWidth, frameHeight);
      if (frameCounter % frameDelay == 0) {
        walkFrame = (walkFrame + 1) % 8;
      }
      break;
    case "jump":
      image(jumpSpritesheet, 
            charX - (jumpFrameWidth - charVisibleWidth)/2, 
            charY - (frameHeight - charVisibleHeight)/2, 
            jumpFrameWidth, frameHeight, 
            jumpFrame * jumpFrameWidth, 0, 
            (jumpFrame + 1) * jumpFrameWidth, frameHeight);
      if (frameCounter % frameDelay == 0) {
        jumpFrame = (jumpFrame + 1) % 5;
      }
      break;
  }
  popMatrix();
  frameCounter++;
}

void handleObstacleCollision(float obstacleX, float obstacleY, float obstacleWidth, float obstacleHeight) {
  float charLeft = charX + collisionOffsetX;
  float charRight = charX + collisionOffsetX + collisionWidth;
  float charTop = charY + collisionOffsetY;
  float charBottom = charY + collisionOffsetY + collisionHeight;
  
  // Horizontal collision
  if (charBottom > obstacleY && charTop < obstacleY + obstacleHeight) {
    if (charRight > obstacleX && charX + collisionOffsetX + collisionWidth <= obstacleX) {
      charX = obstacleX - (collisionOffsetX + collisionWidth);
      charSpeedX = 0;
    }
    if (charLeft < obstacleX + obstacleWidth && charX + collisionOffsetX >= obstacleX + obstacleWidth) {
      charX = obstacleX + obstacleWidth - collisionOffsetX;
      charSpeedX = 0;
    }
  }
  
  // Vertical collision
  if (charRight > obstacleX && charLeft < obstacleX + obstacleWidth) {
    if (charBottom > obstacleY && charY + collisionOffsetY + collisionHeight <= obstacleY) {
      charY = obstacleY - (collisionOffsetY + collisionHeight);
      charSpeedY = 0;
      isJumping = false;
      if (currentState.equals("jump")) {
        currentState = "idle";
      }
    }
    if (charTop < obstacleY + obstacleHeight && charY + collisionOffsetY >= obstacleY + obstacleHeight) {
      charY = obstacleY + obstacleHeight - collisionOffsetY;
      charSpeedY = 0;
    }
  }
}

void handleLevelCompletion() {
  levelCompleted = true;
  if (currentScreen == 2) {
    currentScreen = 3;
    resetLevel();
  } else if (currentScreen == 3) {
    currentScreen = 5;
    hideAllButtons();
    btnBack.setVisible(true);
  }
}

void keyPressed() {
  if (key == 'p' || key == 'P') {
    isPaused = !isPaused;
    if (isPaused) {
      showPauseMenuButtons();
      if (bgm != null) bgm.pause();
    } else {
      hideAllButtons();
      if (bgm != null) bgm.play();
    }
  }
  
  if (!isPaused && !isGameOver) {
    if (key == 'w' || key == 'W') {
      if (!isJumping) {
        charSpeedY = -10;
        isJumping = true;
        currentState = "jump";
        if (jumpSound != null) jumpSound.play();
      }
    }
    if (key == 'd' || key == 'D') {
      charSpeedX = 3;
      isFacingLeft = false;
      if (!isJumping) {
        currentState = "walk";
        if (footstepSound != null && !footstepSound.isPlaying()) {
          footstepSound.play();
        }
      }
    }
    if (key == 'a' || key == 'A') {
      charSpeedX = -3;
      isFacingLeft = true;
      if (!isJumping) {
        currentState = "walk";
        if (footstepSound != null && !footstepSound.isPlaying()) {
          footstepSound.play();
        }
      }
    }
  }
}

void keyReleased() {
  if (!isPaused && !isGameOver) {
    if (key == 'd' || key == 'D' || key == 'a' || key == 'A') {
      charSpeedX = 0;
      if (!isJumping) {
        currentState = "idle";
      }
      if (footstepSound != null && footstepSound.isPlaying()) {
        footstepSound.stop();
      }
    }
  }
}

boolean checkCollision(float x1, float y1, float w1, float h1, float x2, float y2, float w2, float h2) {
  float charActualX = x1 + collisionOffsetX;
  float charActualY = y1 + collisionOffsetY;
  
  return (charActualX < x2 + w2 && 
          charActualX + collisionWidth > x2 && 
          charActualY < y2 + h2 && 
          charActualY + collisionHeight > y2);
}

void handleCollision() {
  isGameOver = true;
  if (fallSound != null) fallSound.play();
  if (bgm != null) bgm.pause();
}

void hideAllButtons() {
  btnPlay.setVisible(false);
  btnAbout.setVisible(false);
  btnCredit.setVisible(false);
  btnQuit.setVisible(false);
  btnResume.setVisible(false);
  btnRestart.setVisible(false);
  btnExitToMenu.setVisible(false);
  btnBack.setVisible(false);
}

void showMainMenuButtons() {
  btnPlay.setVisible(true);
  btnAbout.setVisible(true);
  btnCredit.setVisible(true);
  btnQuit.setVisible(true);
}

void showPauseMenuButtons() {
  btnResume.setVisible(true);
  btnRestart.setVisible(true);
  btnExitToMenu.setVisible(true);
}

void resetGame() {
  charX = 100;
  charY = height - groundHeight - 30;
  charSpeedY = 0;
  charSpeedX = 0;
  isJumping = false;
  isPaused = false;
  isGameOver = false;
  levelCompleted = false;
  currentState = "idle";
  isFacingLeft = false;
  
  if (bgm != null) {
    bgm.stop();
    bgm.loop();
  }
}

void resetLevel() {
  charX = 100;
  charY = height - groundHeight - 30;
  charSpeedY = 0;
  charSpeedX = 0;
  isJumping = false;
  currentState = "idle";
}

// Button event handlers
public void handlePlayButton(GButton button, GEvent event) {
  if (event == GEvent.CLICKED) {
    currentScreen = 2;
    hideAllButtons();
    resetLevel();
    if (buttonClickSound != null) buttonClickSound.play();
  }
}

public void handleAboutButton(GButton button, GEvent event) {
  if (event == GEvent.CLICKED) {
    currentScreen = 4;
    hideAllButtons();
    btnBack.setVisible(true);
    if (buttonClickSound != null) buttonClickSound.play();
  }
}

public void handleCreditButton(GButton button, GEvent event) {
  if (event == GEvent.CLICKED) {
    currentScreen = 5;
    hideAllButtons();
    btnBack.setVisible(true);
    if (buttonClickSound != null) buttonClickSound.play();
  }
}

public void handleQuitButton(GButton button, GEvent event) {
  if (event == GEvent.CLICKED) {
    exit();
  }
}

public void handleResumeButton(GButton button, GEvent event) {
  if (event == GEvent.CLICKED) {
    isPaused = false;
    hideAllButtons();
    if (buttonClickSound != null) buttonClickSound.play();
  }
}

public void handleRestartButton(GButton button, GEvent event) {
  if (event == GEvent.CLICKED) {
    isPaused = false;
    isGameOver = false;
    levelCompleted = false;
    resetLevel();
    hideAllButtons();
    if (buttonClickSound != null) buttonClickSound.play();
    if (bgm != null) {
      bgm.stop();
      bgm.loop();
    }
  }
}

public void handleExitToMenuButton(GButton button, GEvent event) {
  if (event == GEvent.CLICKED) {
    currentScreen = 1;
    resetGame();
    showMainMenuButtons();
    if (buttonClickSound != null) buttonClickSound.play();
  }
}

public void handleBackButton(GButton button, GEvent event) {
  if (event == GEvent.CLICKED) {
    currentScreen = 1;
    showMainMenuButtons();
    btnBack.setVisible(false);
    if (buttonClickSound != null) buttonClickSound.play();
  }
}
