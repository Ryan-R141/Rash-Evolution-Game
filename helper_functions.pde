void plantFirstGen() {

  //set the percentages of each cell 
  for (int i = 0; i < n; i++) {
    for (int j = 0; j < n; j++) {

      float num = random(0, 1);

      if (num < rashpct) {
        if (num < 0.25) {
          if (num < 0.1) {
            cells[i][j] = is;
            isRash[i][j] = true; 
            rashseverity[i][j] = 1;
          } 
          else {
            cells[i][j] = vis;
            isRash[i][j] = true; 
            rashseverity[i][j] = 2;
          }
        } 
        else {
          cells[i][j] = rash;
          isRash[i][j] = true; 
          rashseverity[i][j] = 3;
        }
      } 
      
      else {
        cells[i][j] = skin; 
        isRash[i][j] = false; 
        rashseverity[i][j] = 0;
      }
      
   }
  }
}
      
    
