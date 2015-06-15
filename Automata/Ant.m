//
//  Ant.m
//  Automata
//
//  Created by Linda Cobb on 5/21/14.
//  Copyright (c) 2014 TimesToCome Mobile. All rights reserved.
//

#import "Ant.h"

@implementation Ant



- (id)init
{
    self = [super initWithImageNamed:@"ant"];
    
    if ( self ){
        
        _numberOfGenes = [NSNumber numberWithInt:genes];
            
        // genes 0 down, 1 left, 2 right, 3 up
        _genesArray = [[NSMutableArray alloc] initWithCapacity:self.numberOfGenes.intValue];
        
        for ( int i=0; i<self.numberOfGenes.intValue; i++){
            int g = arc4random()%3 + 1;
            [self.genesArray addObject:[NSNumber numberWithInt:g]];
        }
        
        
        // which direction is ant facing ? 1=N, 2=S, 3=E, 4=W
        _direction = [NSNumber numberWithInt: arc4random()%4+1];
        _startingDirection = self.direction;
        
        // food ++ empty travel --
        _fitness = [NSNumber numberWithInt:0];
        _foodAquired = [NSNumber numberWithInt:0];
        _stepsTaken = [NSNumber numberWithInt:0];
        _lifeTime = [NSNumber numberWithInt:0];
        
        
        self.name = @"ant";
        self.position = CGPointMake(tileSize/2.0, gameBoardHeight * tileSize + tileSize/2.0);
        
        // multiple ants running about at once but each ant only gets to each each food item once
        self.foodArray = [self createFoodArray];
        
    }
    
    return self;
}





- (NSMutableArray *)createFoodArray
{
    NSMutableArray* foodArray = [[NSMutableArray alloc] initWithCapacity:89];
    NSString* s;
   
    
    s = @"0001";
    [foodArray addObject:s];
    
    s = @"0002";
    [foodArray addObject:s];
    
    s = @"0003";
    [foodArray addObject:s];
    
    s = @"0103";
    [foodArray addObject:s];
    
    s = @"0203";
    [foodArray addObject:s];
    
    s = @"0225";
    [foodArray addObject:s];
    
    s = @"0226";
    [foodArray addObject:s];
    
    s = @"0227";
    [foodArray addObject:s];
    
    s = @"0303";
    [foodArray addObject:s];
    
    s = @"0324";
    [foodArray addObject:s];
    
    s = @"0329";
    [foodArray addObject:s];
    
    s = @"0403";
    [foodArray addObject:s];
    
    s = @"0424";
    [foodArray addObject:s];
    
    s = @"0429";
    [foodArray addObject:s];
    
    s = @"0503";
    [foodArray addObject:s];
    
    s = @"0504";
    [foodArray addObject:s];
    
    s = @"0505";
    [foodArray addObject:s];
    
    s = @"0506";
    [foodArray addObject:s];
    
    s = @"0508";
    [foodArray addObject:s];
    
    s = @"0509";
    [foodArray addObject:s];
    
    s = @"0510";
    [foodArray addObject:s];
    
    s = @"0511";
    [foodArray addObject:s];
    
    s = @"0512";
    [foodArray addObject:s];
    
    s = @"0521";
    [foodArray addObject:s];
    
    s = @"0522";
    [foodArray addObject:s];
    
    s = @"0612";
    [foodArray addObject:s];
    
    s = @"0629";
    [foodArray addObject:s];
    
    s = @"0712";
    [foodArray addObject:s];
    
    s = @"0812";
    [foodArray addObject:s];
    
    s = @"0820";
    [foodArray addObject:s];
    
    s = @"0912";
    [foodArray addObject:s];
    
    s = @"0920";
    [foodArray addObject:s];
    
    s = @"0929";
    [foodArray addObject:s];
    
    s = @"1012";
    [foodArray addObject:s];
    
    s = @"1020";
    [foodArray addObject:s];
    
    s = @"1120";
    [foodArray addObject:s];
    
    s = @"1212";
    [foodArray addObject:s];
    
    s = @"1229";
    [foodArray addObject:s];
    
    s = @"1312";
    [foodArray addObject:s];
    
    s = @"1412";
    [foodArray addObject:s];
    
    s = @"1420";
    [foodArray addObject:s];
    
    s = @"1426";
    [foodArray addObject:s];
    
    s = @"1427";
    [foodArray addObject:s];
    
    s = @"1428";
    [foodArray addObject:s];
    
    s = @"1512";
    [foodArray addObject:s];
    
    s = @"1520";
    [foodArray addObject:s];
    
    s = @"1523";
    [foodArray addObject:s];
    
    s = @"1617";
    [foodArray addObject:s];
    
    s = @"1716";
    [foodArray addObject:s];
    
    s = @"1812";
    [foodArray addObject:s];
    
    s = @"1816";
    [foodArray addObject:s];
    
    s = @"1824";
    [foodArray addObject:s];
    
    s = @"1912";
    [foodArray addObject:s];
    
    s = @"1916";
    [foodArray addObject:s];
    
    s = @"1927";
    [foodArray addObject:s];
    
    s = @"2012";
    [foodArray addObject:s];
    
    s = @"2112";
    [foodArray addObject:s];
    
    s = @"2116";
    [foodArray addObject:s];
    
    s = @"2212";
    [foodArray addObject:s];
    
    s = @"2226";
    [foodArray addObject:s];
    
    s = @"2312";
    [foodArray addObject:s];
    
    s = @"2323";
    [foodArray addObject:s];
    
    s = @"2403";
    [foodArray addObject:s];
    
    s = @"2404";
    [foodArray addObject:s];
    
    s = @"2407";
    [foodArray addObject:s];
    
    s = @"2408";
    [foodArray addObject:s];
    
    s = @"2409";
    [foodArray addObject:s];
    
    s = @"2410";
    [foodArray addObject:s];
    
    s = @"2411";
    [foodArray addObject:s];
    
    s = @"2416";
    [foodArray addObject:s];
    
    s = @"2501";
    [foodArray addObject:s];
    
    s = @"2516";
    [foodArray addObject:s];
    
    s = @"2601";
    [foodArray addObject:s];
    
    s = @"2416";
    [foodArray addObject:s];
    
    s = @"2701";
    [foodArray addObject:s];
    
    s = @"2708";
    [foodArray addObject:s];
    
    s = @"2709";
    [foodArray addObject:s];
    
    s = @"2710";
    [foodArray addObject:s];
    
    s = @"2711";
    [foodArray addObject:s];
    
    s = @"2712";
    [foodArray addObject:s];
    
    s = @"2713";
    [foodArray addObject:s];
    
    s = @"2714";
    [foodArray addObject:s];
    
    s = @"2801";
    [foodArray addObject:s];
    
    s = @"2807";
    [foodArray addObject:s];
    
    s = @"2907";
    [foodArray addObject:s];
    
    s = @"3002";
    [foodArray addObject:s];
    
    s = @"3003";
    [foodArray addObject:s];
    
    s = @"3004";
    [foodArray addObject:s];
    
    s = @"3005";
    [foodArray addObject:s];
    
    
    return foodArray;
}





@end
