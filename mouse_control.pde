void mouseWheel() {
  //applies a skincare product to heal the rash 
  int col = int((mouseX - padding)/cellSize);
  int row = int((mouseY - padding)/cellSize);
  
  isRashNext[row][col] = isRashNext[row][col];
  cellsNext[row][col] = skincareproduct;
  rashseverityNext[row][col] = rashseverityNext[row][col] - skincareproducteffectiveness;
  copyNextGenToCurrentGen();
}

void mouseDragged() {
  //scratches the rash 
  int col = int((mouseX - padding)/cellSize);
  int row = int((mouseY - padding)/cellSize);
  
  float num = random(0, 1); 
  
  isRashNext[row][col] = true;
  
  //chance the cell becomes infected 
  if (num < infectionchance) {
    cellsNext[row][col] = infection;
    rashseverityNext[row][col] = 0;
  }
  else {
  cellsNext[row][col] = scratchrash;
  rashseverityNext[row][col] = 10;
  }
  copyNextGenToCurrentGen();
}
