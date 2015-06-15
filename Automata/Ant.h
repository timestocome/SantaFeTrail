//
//  Ant.h
//  Automata
//
//  Created by Linda Cobb on 5/21/14.
//  Copyright (c) 2014 TimesToCome Mobile. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>




@interface Ant : SKSpriteNode

@property (nonatomic, strong) NSMutableArray*       genesArray;
@property (nonatomic, strong) NSMutableArray*       foodArray;

@property (nonatomic, strong) NSNumber*             direction;
@property (nonatomic, strong) NSNumber*             startingDirection;
@property (nonatomic, strong) NSNumber*             fitness;
@property (nonatomic, strong) NSNumber*             foodAquired;
@property (nonatomic, strong) NSNumber*             stepsTaken;
@property (nonatomic, strong) NSNumber*             numberOfGenes;
@property (nonatomic, strong) NSNumber*             lifeTime;
@property (nonatomic, strong) NSNumber*             tag;

- (NSMutableArray *)createFoodArray;


@end
