//
//  World.m
//  Automata
//
//  Created by Linda Cobb on 5/8/14.
//  Copyright (c) 2014 TimesToCome Mobile. All rights reserved.
//

#import "World.h"
#import "Ant.h"


@implementation World



typedef NS_OPTIONS(uint32_t, PhyicsCategory)
{
    bodyAnt = 1 << 0,
    bodyFood = 1 << 1,
};





- (instancetype)createWorld
{
    _atlas = [SKTextureAtlas atlasNamed:@"Sprites"];
    width = tileSize * gameBoardWidth;
    height = tileSize * gameBoardHeight;
    self.layerSize = CGSizeMake(gameBoardHeight * tileSize, gameBoardWidth * tileSize);
    
    
    
    // init food source grid
    _foodLocations = [[NSMutableArray alloc] initWithCapacity:(gameBoardHeight * gameBoardWidth)];
    for ( int i=0; i<gameBoardWidth; i++){
        for ( int j=0; j<gameBoardHeight; j++){
            gameBoard[i][j] = 0;
            _foodLocations[i*gameBoardWidth + j] = [NSNumber numberWithInt:0];
        }
    }
    [self layOutFoodSources];
    
    
    [self createAnts];
    
    
    return self;
}




- (void)layOutFoodSources
{
    gameBoard[0][1] = food;
    gameBoard[0][2] = food;
    gameBoard[0][3] = food;
    
    gameBoard[1][3] = food;
    
    gameBoard[2][3] = food;
    gameBoard[2][25] = food;
    gameBoard[2][26] = food;
    gameBoard[2][27] = food;
    
    gameBoard[3][3] = food;
    gameBoard[3][24] = food;
    gameBoard[3][29] = food;
    
    gameBoard[4][3] = food;
    gameBoard[4][24] = food;
    gameBoard[4][29] = food;
    
    gameBoard[5][3] = food;
    gameBoard[5][4] = food;
    gameBoard[5][5] = food;
    gameBoard[5][6] = food;
    gameBoard[5][8] = food;
    gameBoard[5][9] = food;
    gameBoard[5][10] = food;
    gameBoard[5][11] = food;
    gameBoard[5][12] = food;
    gameBoard[5][21] = food;
    gameBoard[5][22] = food;
    
    gameBoard[6][12] = food;
    gameBoard[6][29] = food;
    
    gameBoard[7][12] = food;
    
    gameBoard[8][12] = food;
    gameBoard[8][20] = food;
    
    
    gameBoard[9][12] = food;
    gameBoard[9][20] = food;
    gameBoard[9][29] = food;
    
    gameBoard[10][12] = food;
    gameBoard[10][20] = food;
    
    gameBoard[11][20] = food;
    
    gameBoard[12][12] = food;
    gameBoard[12][29] = food;
    
    gameBoard[13][12] = food;
    
    gameBoard[14][12] = food;
    gameBoard[14][20] = food;
    gameBoard[14][26] = food;
    gameBoard[14][27] = food;
    gameBoard[14][28] = food;
    
    gameBoard[15][12] = food;
    gameBoard[15][20] = food;
    gameBoard[15][23] = food;
    
    gameBoard[16][17] = food;
    
    gameBoard[17][16] = food;
    
    gameBoard[18][12] = food;
    gameBoard[18][16] = food;
    gameBoard[18][24] = food;

    gameBoard[19][12] = food;
    gameBoard[19][16] = food;
    gameBoard[19][27] = food;
    
    gameBoard[20][12] = food;
    
    gameBoard[21][12] = food;
    gameBoard[21][16] = food;
    
    gameBoard[22][12] = food;
    gameBoard[22][26] = food;
    
    gameBoard[23][12] = food;
    gameBoard[23][23] = food;
    
    gameBoard[24][3] = food;
    gameBoard[24][4] = food;
    gameBoard[24][7] = food;
    gameBoard[24][8] = food;
    gameBoard[24][9] = food;
    gameBoard[24][10] = food;
    gameBoard[24][11] = food;
    gameBoard[24][16] = food;
    
    gameBoard[25][1] = food;
    gameBoard[25][16] = food;
    
    gameBoard[26][1] = food;
    gameBoard[26][16] = food;
    
    
    gameBoard[27][1] = food;
    gameBoard[27][8] = food;
    gameBoard[27][9] = food;
    gameBoard[27][10] = food;
    gameBoard[27][11] = food;
    gameBoard[27][12] = food;
    gameBoard[27][13] = food;
    gameBoard[27][14] = food;
    
    
    gameBoard[28][1] = food;
    gameBoard[28][7] = food;
    
    gameBoard[29][7] = food;
    
    gameBoard[30][2] = food;
    gameBoard[30][3] = food;
    gameBoard[30][4] = food;
    gameBoard[30][5] = food;
    
    
    
    int top = gameBoardHeight * tileSize;
    
    for ( int i=0; i<gameBoardWidth; i++){
        for ( int j=0; j<gameBoardHeight; j++){
            if ( gameBoard[i][j] == food ){
                
                SKNode* foodSource = [SKSpriteNode spriteNodeWithColor:[UIColor greenColor] size:CGSizeMake(tileSize, tileSize)];
                foodSource.position = CGPointMake(j*tileSize + tileSize/2.0, top - i * tileSize + tileSize/2.0);
                foodSource.physicsBody.collisionBitMask = bodyFood;
                foodSource.physicsBody.contactTestBitMask = bodyFood;
                foodSource.physicsBody.allowsRotation = NO;
                [self addChild:foodSource];

                self.foodLocations[i*gameBoardWidth + j] = [NSNumber numberWithInt:food];
            }
        }
    }
    
    
    
}








// direction 1 = N, 2, S, 3 = E, 4 = W
// genes 1 = same direction, 2 = turn left, 3 = turn right

-(void)createAnts
{
    for ( int i=0; i<numberOfAnts; i++){
        Ant* ant = [[Ant alloc] init];
        ant.tag = [NSNumber numberWithInt:i];
        [self addChild:ant];
        
    }
}






@end
