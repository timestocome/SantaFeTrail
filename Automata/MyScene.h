//
//  MyScene.h
//  Automata
//

//  Copyright (c) 2014 TimesToCome Mobile. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "World.h"



@interface MyScene : SKScene <SKPhysicsContactDelegate>
{

    CGSize  worldSize;
    CGSize  windowSize;
    int     gameBoard[gameBoardWidth][gameBoardHeight];
    int     foodLocations[gameBoardWidth][gameBoardHeight];
    int     numberOfTiles;
    int     genomeNumber;
    int     updateNumber;
    int     generation;
    int     bestFitness;
    int     lastBest;
    float   percentToMate;
  }



@property (nonatomic, retain) World* worldNode;
@property (nonatomic, retain) SKNode* universeNode;
@property (nonatomic, retain) SKTextureAtlas* atlas;



@end
