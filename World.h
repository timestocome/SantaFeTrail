//
//  World.h
//  Automata
//
//  Created by Linda Cobb on 5/8/14.
//  Copyright (c) 2014 TimesToCome Mobile. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>





@interface World : SKNode
{
    float   height;
    float   width;
    int     gameBoard[gameBoardWidth][gameBoardHeight];
}


@property (nonatomic, retain) SKTextureAtlas* atlas;
@property (nonatomic, retain) NSMutableArray* foodLocations;
@property CGSize layerSize;

- (instancetype)createWorld;


@end
