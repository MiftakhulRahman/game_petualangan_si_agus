void loadAssets() {
  // Load images
  backgroundImg = loadImage("rock.png");
  groundImg = loadImage("ground.png");
  idleSpritesheet = loadImage("idle_spritesheet.png");
  walkSpritesheet = loadImage("walk_spritesheet.png");
  jumpSpritesheet = loadImage("jump_spritesheet.png");
  obstacleImage = loadImage("obstacles11.png");
  titleImage = loadImage("title_agus.png");
  
  // Load sounds
  bgm = new SoundFile(this, "Contemplative.mp3");
  jumpSound = new SoundFile(this, "Jump.wav");
  fallSound = new SoundFile(this, "jatuh_sehabis_lompat.ogg");
  footstepSound = new SoundFile(this, "sound_langkah_kaki.ogg");
  buttonClickSound = new SoundFile(this, "switch36.ogg");
  
  // Verify assets
  if (backgroundImg == null || groundImg == null || idleSpritesheet == null || 
      walkSpritesheet == null || jumpSpritesheet == null || obstacleImage == null || 
      titleImage == null || bgm == null || jumpSound == null || fallSound == null || 
      footstepSound == null || buttonClickSound == null) {
    println("Error: One or more assets could not be loaded.");
    exit();
  }
}
