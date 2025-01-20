void createGUI() {
  G4P.messagesEnabled(false);
  G4P.setGlobalColorScheme(7); // Using custom scheme
  G4P.setMouseOverEnabled(true);
  
  // Button dimensions and positioning
  int buttonWidth = 200;
  int buttonHeight = 40;
  int startY = 300;
  int spacing = 60;
  int centerX = width/2 - buttonWidth/2;
  
  // Main Menu buttons
  btnPlay = new GButton(this, centerX, startY, buttonWidth, buttonHeight, "Play");
  styleButton(btnPlay);
  
  btnAbout = new GButton(this, centerX, startY + spacing, buttonWidth, buttonHeight, "About");
  styleButton(btnAbout);
  
  btnCredit = new GButton(this, centerX, startY + spacing * 2, buttonWidth, buttonHeight, "Credits");
  styleButton(btnCredit);
  
  btnQuit = new GButton(this, centerX, startY + spacing * 3, buttonWidth, buttonHeight, "Quit");
  styleButton(btnQuit);
  
  // Pause Menu buttons
  btnResume = new GButton(this, centerX, height/2 - spacing, buttonWidth, buttonHeight, "Resume");
  styleButton(btnResume);
  
  btnRestart = new GButton(this, centerX, height/2, buttonWidth, buttonHeight, "Restart");
  styleButton(btnRestart);
  
  btnExitToMenu = new GButton(this, centerX, height/2 + spacing, buttonWidth, buttonHeight, "Exit to Menu");
  styleButton(btnExitToMenu);
  
  btnBack = new GButton(this, centerX, height - 100, buttonWidth, buttonHeight, "Back");
  styleButton(btnBack);
  
  // Add event handlers
  btnPlay.addEventHandler(this, "handlePlayButton");
  btnAbout.addEventHandler(this, "handleAboutButton");
  btnCredit.addEventHandler(this, "handleCreditButton");
  btnQuit.addEventHandler(this, "handleQuitButton");
  btnResume.addEventHandler(this, "handleResumeButton");
  btnRestart.addEventHandler(this, "handleRestartButton");
  btnExitToMenu.addEventHandler(this, "handleExitToMenuButton");
  btnBack.addEventHandler(this, "handleBackButton");
  
  hideAllButtons();
}

void styleButton(GButton button) {
  button.setFont(new java.awt.Font("Arial", java.awt.Font.BOLD, 16));
  button.setLocalColorScheme(7);
  
}

void draw() {
  switch(currentScreen) {
    case 0: // Title
      drawTitleScreen();
      break;
    case 1: // Main Menu
      drawMainMenu();
      break;
    case 2: // Level 1
    case 3: // Level 2
      if (!isPaused && !isGameOver) {
        drawLevel(currentScreen - 1);
      } else if (isPaused) {
        drawPauseMenu();
      } else if (isGameOver) {
        drawGameOver();
      }
      break;
    case 4: // About
      drawAboutScreen();
      break;
    case 5: // Credits
      drawCreditsScreen();
      break;
  }
}

void drawTitleScreen() {
  background(backgroundImg);
  
  // Draw semi-transparent overlay
  fill(0, 0, 0, 100);
  rect(0, 0, width, height);
  
  // Draw title
  image(titleImage, width/2 - titleImage.width/2, height/4);
  
  // Draw prompt text
  textAlign(CENTER);
  textSize(20);
  fill(textColor);
  text("Press ENTER to continue", width/2, height - 100);
  
  if (keyPressed && key == ENTER) {
    currentScreen = 1;
    showMainMenuButtons();
    if (buttonClickSound != null) buttonClickSound.play();
  }
}

void drawMainMenu() {
  background(backgroundImg);
  
  // Draw semi-transparent overlay
  fill(0, 0, 0, 100);
  rect(0, 0, width, height);
  
  // Draw title
  image(titleImage, width/2 - titleImage.width/2, height/4);
  showMainMenuButtons();
}

void drawLevel(int level) {
  int[][] obstacles = (level == 1) ? obstaclesLevel1 : obstaclesLevel2;
  int[][] gaps = (level == 1) ? gapsLevel1 : gapsLevel2;
  
  background(backgroundImg);
  image(groundImg, 0, height - groundHeight, width, groundHeight);
  
  if (!isPaused) {
    // Store previous position for collision detection
    float prevX = charX;
    float prevY = charY;
    
    charSpeedY += 0.5;
    charY += charSpeedY;
    charX += charSpeedX;
    
    // Check ground collision
    if (charY > height - groundHeight - 50) {
      charY = height - groundHeight - 50;
      charSpeedY = 0;
      isJumping = false;
      if (currentState.equals("jump")) {
        currentState = "idle";
      }
    }
    
    // Check obstacle collisions
    for (int[] obs : obstacles) {
      float obstacleX = obs[0];
      float obstacleY = obs[1] - 64;
      float obstacleWidth = 64;
      float obstacleHeight = 64;
      
      // Calculate collision bounds
      float charLeft = charX + collisionOffsetX;
      float charRight = charX + collisionOffsetX + collisionWidth;
      float charTop = charY + collisionOffsetY;
      float charBottom = charY + collisionOffsetY + collisionHeight;
      
      // Horizontal collision
      if (charBottom > obstacleY && charTop < obstacleY + obstacleHeight) {
        if (charRight > obstacleX && prevX + collisionOffsetX + collisionWidth <= obstacleX) {
          charX = obstacleX - (collisionOffsetX + collisionWidth);
          charSpeedX = 0;
        }
        if (charLeft < obstacleX + obstacleWidth && prevX + collisionOffsetX >= obstacleX + obstacleWidth) {
          charX = obstacleX + obstacleWidth - collisionOffsetX;
          charSpeedX = 0;
        }
      }
      
      // Vertical collision
      if (charRight > obstacleX && charLeft < obstacleX + obstacleWidth) {
        if (charBottom > obstacleY && prevY + collisionOffsetY + collisionHeight <= obstacleY) {
          charY = obstacleY - (collisionOffsetY + collisionHeight);
          charSpeedY = 0;
          isJumping = false;
          if (currentState.equals("jump")) {
            currentState = "idle";
          }
        }
        if (charTop < obstacleY + obstacleHeight && prevY + collisionOffsetY >= obstacleY + obstacleHeight) {
          charY = obstacleY + obstacleHeight - collisionOffsetY;
          charSpeedY = 0;
        }
      }
      
      image(obstacleImage, obstacleX, obstacleY, obstacleWidth, obstacleHeight);
    }
  }
  
  for (int[] obs : obstacles) {
    float obstacleX = obs[0];
    float obstacleY = obs[1] - 64;
    float obstacleWidth = 64;
    float obstacleHeight = 64;
    
    image(obstacleImage, obstacleX, obstacleY, obstacleWidth, obstacleHeight);
    
    float charLeft = charX;
    float charRight = charX + 40;
    float charBottom = charY + 50;
    
    boolean isOnPlatformX = charRight > obstacleX && charLeft < obstacleX + obstacleWidth;
    boolean isOnPlatformY = Math.abs(charBottom - obstacleY) <= 2;
    
    if (isOnPlatformX) {
      if (charSpeedY > 0 && charBottom >= obstacleY && charBottom <= obstacleY + 10) {
        charY = obstacleY - 50;
        charSpeedY = 0;
        isJumping = false;
        if (currentState.equals("jump")) {
          currentState = "idle";
        }
      }
    } else if (charBottom == obstacleY) {
      charSpeedY = 0.5;
    }
  }
  
  for (int[] gap : gaps) {
    fill(0);
    rect(gap[0], height - groundHeight, gap[1] - gap[0], groundHeight);
    if (charX + 40 > gap[0] && charX < gap[1] && charY + 50 >= height - groundHeight) {
      isGameOver = true;
      if (fallSound != null) fallSound.play();
    }
  }
  
  animateCharacter();
  
  if (charX > width - 50) {
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
}
