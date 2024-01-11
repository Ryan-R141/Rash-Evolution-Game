//user settings
int n = 50;

color rash = color(255, 100, 100);
color is = color(255, 153, 153); //irritated skin
color skin = color(255, 204, 204);
color vis = color(255, 125, 125); //very irritated skin
color scratchrash = color(255, 75, 75);
color infection = color(0, 150, 0);
color skincareproduct = color(0, 0, 150);

//user values
float rashpct = 0.5; // percent of rash, irritated skin and very irritated skin
float infectionpctcell = 0.03; // aggression of infection, percent chance of infection of healthy skin cell per cell
float infectionchance = 0.03; // chance of infection when scratching 
int skincareproducteffectiveness = 5; // the effectiveness of skincare product, how much it reduces the rash severity

//global variables 
int padding = 50;
float cellSize;

color[][] cells = new color[n][n];
color[][] cellsNext = new color[n][n];

boolean[][] isRash = new boolean[n][n];
boolean[][] isRashNext = new boolean[n][n];

int[][] rashseverity = new int[n][n]; 
int[][] rashseverityNext = new int[n][n]; 

int[][] numANarray = new int[n][n];
//int[][] numANarrayNext = new int[n][n];

void setup() {
  size(600, 600);
  //noStroke();
  frameRate(1);
  cellSize = (width-2*padding)/n;
  plantFirstGen();
}


void draw() {

  float y = padding;
  for (int i=0; i<n; i++) {
    for (int j=0; j<n; j++) {
      float x = padding + j*cellSize;
      
      fill(cells[i][j]);
      square(x, y, cellSize);
      //textSize(25); 
      //stroke(0);
      //fill(0);
      //text(numANarray[i][j], x, y+cellSize);
    }

    y+=cellSize;
  }

  setNextGeneration();
  copyNextGenToCurrentGen();
}

void setNextGeneration() { 
  
  //checks surrounding cells and adds the rash severity 
    for (int i = 0; i < n; i++) {
    for (int j = 0; j < n; j++) {
      int numAN = 0; 
      for (int k = -1; k <= 1; k++) {
        for (int l = -1; l <= 1; l++) {
          try {
            if ( isRash[i+k][j+l] == true && (k != 0 || l !=0)) 
              numAN = numAN + rashseverity[i+k][j+l];
          }
          catch (Exception e) {
          }
          
          //float numANaverage = numAN / 8;
        }
      }
      
      numANarray[i][j] = numAN; 
      //println(i, j, numANarray[i][j]);
     
     //checks the different types of cells
     
     //rash after being scratched
     //stays scratchrash if the the rash severity is over 30, becomes rash if it is less
     if (cells[i][j] == scratchrash) {
       if (numAN > 30) {
          isRashNext[i][j] = true;
          cellsNext[i][j] = scratchrash;
          rashseverityNext[i][j] = 10; 
       }
       else {
          isRashNext[i][j] = true;
          cellsNext[i][j] = rash;
          rashseverityNext[i][j] = 3; 
       }
     }
     
     //infected cell
     else if (cells[i][j] == infection) {
       isRashNext[i][j] = false; 
       cellsNext[i][j] = infection;
       rashseverityNext[i][j] = 0; 
     }
     
     //rash cell, can become a very irritated cell if the surrounding cells have less rash severity
     else if (cells[i][j] == rash) {
        if (numAN > 16) {
          isRashNext[i][j] = true;
          cellsNext[i][j] = rash;
          rashseverityNext[i][j] = 3; 
        } 
        else {
          isRashNext[i][j] = true;
          cellsNext[i][j] = vis;
          rashseverityNext[i][j] = 2; 
        }
     }
     
     //very irritated skin cell, can become a rash, stay the same or become an irritated skin cell
     else if (cells[i][j] == vis) {
       if (numAN > 12) {
         if (numAN > 15) {
           isRashNext[i][j] = true;
           cellsNext[i][j] = rash;
           rashseverityNext[i][j] = 3; 
         }
         else {
          isRashNext[i][j] = true;
          cellsNext[i][j] = vis;
          rashseverityNext[i][j] = 2; 
         }
       }
      else {
       isRashNext[i][j] = true;
       cellsNext[i][j] = is;
       rashseverityNext[i][j] = 1;
     }
     }
     
     // irritated skin cell, can become a very irritated skin cell, stay the same, or become a skin cell
     else if (cells[i][j] == is) {
       if (numAN > 8) {
         if (numAN > 11) {
           isRashNext[i][j] = true;
           cellsNext[i][j] = vis;
           rashseverityNext[i][j] = 2; 
         }
         else {
          isRashNext[i][j] = true;
          cellsNext[i][j] = is;
          rashseverityNext[i][j] = 1; 
         }
       }
     else {
       isRashNext[i][j] = false;
       cellsNext[i][j] = skin;
       rashseverityNext[i][j] = 0;
     }
     }
     
     //skin cell, can stay the same or become a irritated skin cell
     else {
       if (numAN > 5) {
         isRashNext[i][j] = true;
         cellsNext[i][j] = is;
         rashseverityNext[i][j] = 1; 
       }
       else {
       isRashNext[i][j] = false;
       cellsNext[i][j] = skin;
       rashseverityNext[i][j] = 0;
     }
     }
     
    }
    }
    
    checkneighbouringinfectedcells(); 
    
}

//checks neigbouring cells to see if they are infected
void checkneighbouringinfectedcells() {
  for (int i = 0; i < n; i++) {
    for (int j = 0; j < n; j++) {
      int numAC = 0; 
      for (int k = -1; k <= 1; k++) {
        for (int l = -1; l <= 1; l++) {
          try {
            if ( cells[i+k][j+l] == infection && (k != 0 || l !=0)) 
              numAC ++;
          }
          catch (Exception e) {
          }
          
        }
      }
      
      //probability that the cell becomes infected by neighbouring cells
      float infectionpct = numAC * infectionpctcell; 
      float num = random (0, 1); 
      
      try {
      if (num < infectionpct) {
       isRashNext[i][j] = false;
       cellsNext[i][j] = infection;
       rashseverityNext[i][j] = 0;
      }
      }
      catch(Exception e) {
      }
      
    }
    }
}
 

void copyNextGenToCurrentGen() {
  for (int i=0; i<n; i++) {
    for (int j=0; j<n; j++) {
      cells[i][j] = cellsNext[i][j];
      isRash[i][j] = isRashNext[i][j];
      rashseverity[i][j] = rashseverityNext[i][j];
      
    }
  }
}
