//
//  MyScene.m
//  Automata
//
//  Created by Linda Cobb on 5/6/14.
//  Copyright (c) 2014 TimesToCome Mobile. All rights reserved.
//

#import "MyScene.h"
#import "Ant.h"



@implementation MyScene



-(id)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size]) {
        
        self.backgroundColor = [SKColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
        self.physicsWorld.contactDelegate = self;
        self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
        self.physicsWorld.gravity = CGVectorMake(0, 0);
        genomeNumber = 0;
        updateNumber = 0;
        generation = 0;
        bestFitness = 0;
        percentToMate = 0.4;
        
        _atlas = [SKTextureAtlas atlasNamed:@"Sprites"];

        [self createUniverse];
    }
    
    return self;
}




- (void)createUniverse
{
    // create world
    _universeNode = [SKNode node];
    
    // get sizes
    windowSize = CGSizeMake(self.frame.size.width, self.frame.size.height);
    worldSize = CGSizeMake( self.worldNode.layerSize.width, self.worldNode.layerSize.height );
    numberOfTiles = gameBoardWidth * gameBoardHeight;

    

    // create game board
    _worldNode = [[World new] createWorld];
    [self.universeNode addChild:self.worldNode];
    
        
    [self addChild:self.universeNode];
    self.universeNode.position = CGPointMake(0.0, 0.0);
    
    // food locations
    int z = 0;
    for ( int i=0; i<gameBoardWidth; i++){
        for ( int j=0; j<gameBoardHeight; j++){
            foodLocations[i][j] = ((NSNumber *)self.worldNode.foodLocations[z]).intValue;
            z++;
        }
    }
}





// Called before each frame is rendered
-(void)update:(CFTimeInterval)currentTime
{
    if ( generation < maxGenerations){
        updateNumber++;         // steps per life between matings
        if ( updateNumber > max ){
            [self evolve];
            updateNumber = 0;
        }
    
        if ( genomeNumber < genes-1 ){      // walk through one gene each step, then loop back to start
            [self updateAnts:genomeNumber];
            genomeNumber++;

        }else { genomeNumber = 0; }
    }
    
}





- (void)evolve
{
    generation++;
    
    
    // let's evolve the top ?%
    // remove the bottom ?% of ants from scene
    // for i<50% mix two ants and add new one to the scene
    NSMutableArray *evolutionArray = [[NSMutableArray alloc] initWithCapacity:numberOfAnts];
    
    [self.worldNode enumerateChildNodesWithName:@"ant" usingBlock:^(SKNode* node, BOOL* stop){
        Ant* ant = (Ant *)node;
        [evolutionArray addObject:ant];
    }];
    
    
    
    // sort ants by fiteness, highest values are at end of array
    NSArray* sortedArray;
    sortedArray = [evolutionArray sortedArrayUsingComparator:^NSComparisonResult(id a, id b){
        NSNumber* first = [(Ant*)a foodAquired];
        NSNumber* second = [(Ant*)b foodAquired];
        return [first compare:second];
    }];
    
    NSMutableArray* sortedMutableArray = [NSMutableArray arrayWithArray:sortedArray];
    
    // how long since the top ant got smarter?
    Ant *topAnt = [sortedMutableArray objectAtIndex:sortedMutableArray.count-1];
    
    
    // remove first ants in array from scene as unfit
    int numberOfAntsToMate = numberOfAnts - ( numberOfAnts * percentToMate );
    for ( int i=0; i<numberOfAntsToMate; i++){
        Ant* ant = [sortedArray objectAtIndex:i];
        [ant removeFromParent];
        [sortedMutableArray removeObject:ant];
    }
    

    sortedArray = nil;
    evolutionArray = nil;
    
    // now mate remaining ones and add to scene
    float fitnessAverage = 0;
    float foodAverage = 0;
    int splitOfGenes = genes/2;
    int existingAnts = sortedMutableArray.count;
    int newAnts = 0;
    int j = existingAnts - 1;
    
    Ant* ant1;
    Ant* ant2;
    Ant* newAnt;
    
    while ( (newAnts + existingAnts) < numberOfAnts ){      // bring us back to our orignal number of ants
        
        if ( j > 1 ){
            ant1 = [sortedMutableArray objectAtIndex:j];
            ant2 = [sortedMutableArray objectAtIndex:j-1];
            
            j--;
        }
        
        fitnessAverage += (ant1.fitness.intValue + ant2.fitness.intValue)/2.0;  // mating population fitness
        foodAverage += (ant1.foodAquired.intValue + ant2.foodAquired.intValue)/2.0;
        
        // create new ant
        newAnt = [[Ant alloc] init];
   
        // overwrite random genes with parents genes
        // part from one parent, part from the other
        splitOfGenes = arc4random()%(genes);      // how much of mom and how much of dad do we inherit?
        
        // first child
        for( int i=0; i<splitOfGenes; i++){
            newAnt.genesArray[i] = [ant1.genesArray objectAtIndex:i];
        }
        for ( int i=splitOfGenes; i<genes; i++){
            newAnt.genesArray[i] = [ant2.genesArray objectAtIndex:i];
        }
        
        
        // second child switches parents
        splitOfGenes = arc4random()%(genes);      // how much of mom and how much of dad do we inherit?
        for( int i=0; i<splitOfGenes; i++){
            newAnt.genesArray[i] = [ant2.genesArray objectAtIndex:i];
        }
        for ( int i=splitOfGenes; i<genes; i++){
            newAnt.genesArray[i] = [ant1.genesArray objectAtIndex:i];
        }
        
          
        
        // randomize some of our new ants with genetic mutations
        int genesToMutate = 8;
        
        if ( arc4random()%2 == 0 ){
            for ( int k=0; k<genesToMutate; k++){
                newAnt.genesArray[arc4random()%genes] = [NSNumber numberWithInt:arc4random()%3 + 1];
            }
        }
        
        
        // add new ant to the scene
        [self.worldNode addChild:newAnt];
        newAnts++;
        
    }  // end mating and creating new ants
    
    
    
    
    // are we making progress ?
    // if not randomize a few things if we've plateau'd too long
    fitnessAverage = fitnessAverage / numberOfAnts;
    foodAverage = foodAverage / numberOfAnts;
    lastBest = bestFitness;
    if ( fitnessAverage > bestFitness ){ bestFitness = fitnessAverage; }
    
    NSLog(@"generation #%d, mating ants food %.1lf, top ant life: %@, food %@", generation, foodAverage, topAnt.lifeTime, topAnt.foodAquired);
    
    
    
    
    // reset ants
    genomeNumber = 0;       // start each ant at the beginning again
    [self.worldNode enumerateChildNodesWithName:@"ant" usingBlock:^(SKNode* node, BOOL* stop){
        Ant* ant = (Ant *)node;
        ant.fitness = [NSNumber numberWithInt:0];
        ant.position = CGPointMake(tileSize/2.0, gameBoardHeight * tileSize + tileSize/2.0);
        ant.foodArray = [ant createFoodArray];
        ant.foodAquired = [NSNumber numberWithInt:0];
        ant.stepsTaken = [NSNumber numberWithInt:0];
        ant.direction = ant.startingDirection;
        ant.lifeTime = [NSNumber numberWithInt:ant.lifeTime.intValue + 1];
    }];
    
    
    // clean up
    evolutionArray = nil;
}






// direction 1 = N, 2, S, 3 = E, 4 = W
// genes 1 = same direction, 2 = turn left, 3 = turn right
- (void)updateAnts:(int)genome
{
    [self.worldNode enumerateChildNodesWithName:@"ant" usingBlock:^(SKNode* node, BOOL* stop){
        
        Ant* ant = (Ant *)node;

        CGPoint currentLocation = ant.position;
        int x = (int)(currentLocation.x/tileSize);
        int y = (int)(currentLocation.y/tileSize);
        
        int direction = [ant.direction intValue];
        int rotation = [[ant.genesArray objectAtIndex:genome]intValue];
        int foundFood = 0;
        int foodPoints = 1;
        int movePoints = 0;
        
        // is there food in front?
        //    yes - pick up food, move forward one block
        //    else rotate one gene ( left or right )  or move forward
        //
        
        // check for food and move forward if so
        if ( direction == 1 ){              // north ( up )
            if ( y < gameBoardHeight - 1 ){
                
                // see if there is food and it's still there
                NSString* foodLocation = [NSString stringWithFormat:@"%02d%02d", x, y+1];
                int foodExists = [ant.foodArray indexOfObject:foodLocation];
                
                // remove it from the array and give the ant fitness point
                // then move the ant to that spot
                if ( foodExists > 0 && foodExists < ant.foodArray.count ){
                    [ant.foodArray removeObjectAtIndex:foodExists];
                    ant.fitness = [NSNumber numberWithInt:(ant.fitness.intValue + foodPoints)];
                    
                    ant.position = CGPointMake(currentLocation.x, currentLocation.y + tileSize);
                    foundFood = 1;
                    ant.foodAquired = [NSNumber numberWithInt:ant.foodAquired.intValue + 1];

                }
            }
        }else if ( direction == 2 ){        // south ( down )
            if ( y > 0 ){
                
                // see if there is food and it's still there
                NSString* foodLocation = [NSString stringWithFormat:@"%02d%02d", x, y-1];
                int foodExists = [ant.foodArray indexOfObject:foodLocation];

                // remove it from the array and give the ant fitness point
                // then move the ant to that spot
                if ( foodExists > 0 && foodExists < ant.foodArray.count){
                    [ant.foodArray removeObjectAtIndex:foodExists];
                    ant.fitness = [NSNumber numberWithInt:(ant.fitness.intValue + foodPoints)];
                    
                    ant.position = CGPointMake(currentLocation.x, currentLocation.y - tileSize);
                    foundFood = 1;
                    ant.foodAquired = [NSNumber numberWithInt:ant.foodAquired.intValue + 1];

                }
            }
            
        }else if ( direction == 3 ){        // east ( right )
            if ( x < gameBoardWidth - 1 ){
                
                // see if there is food and it's still there
                NSString* foodLocation = [NSString stringWithFormat:@"%02d%02d", x+1, y];
                int foodExists = [ant.foodArray indexOfObject:foodLocation];

                // remove it from the array and give the ant fitness point
                // then move the ant to that spot
                if ( foodExists > 0 && foodExists < ant.foodArray.count){
                    [ant.foodArray removeObjectAtIndex:foodExists];
                    ant.fitness = [NSNumber numberWithInt:(ant.fitness.intValue + foodPoints)];
                    
                    ant.position = CGPointMake(currentLocation.x + tileSize, currentLocation.y);
                    foundFood = 1;
                    ant.foodAquired = [NSNumber numberWithInt:ant.foodAquired.intValue + 1];

                }
                
            }
        }else if ( direction == 4 ){        // west ( left )
            if ( x > 0 ){
                
                // see if there is food and it's still there
                NSString* foodLocation = [NSString stringWithFormat:@"%02d%02d", x-1, y];
                int foodExists = [ant.foodArray indexOfObject:foodLocation];

                // remove it from the array and give the ant fitness point
                // then move the ant to that spot
                if ( foodExists > 0 && foodExists < ant.foodArray.count){
                    [ant.foodArray removeObjectAtIndex:foodExists];
                    ant.fitness = [NSNumber numberWithInt:(ant.fitness.intValue + foodPoints)];
                    
                    ant.position = CGPointMake(currentLocation.x - tileSize, currentLocation.y);
                    foundFood = 1;
                    ant.foodAquired = [NSNumber numberWithInt:ant.foodAquired.intValue + 1];

                }
                
            }

        }
        
        // if no food check gene and rotate left, right or move forward
        if ( foundFood == 0 ){
            
            // if rotation == 1 no change in direction
            if ( rotation == 2 ){ // left
                if ( direction == 1 ){          direction = 4;  // west
                }else if ( direction == 2 ){    direction = 3;  // east
                }else if ( direction == 3 ){    direction = 1;  // north
                }else if ( direction == 4 ){    direction = 2;  // south
                }
            }else if ( rotation == 3 ){ // right
                if ( direction == 1 ){          direction = 3;  // east
                }else if ( direction == 2 ){    direction = 4;  // west
                }else if ( direction == 3 ){    direction = 2;  // south
                }else if ( direction == 4 ){    direction = 1;  // north
                }
            }
            ant.direction = [NSNumber numberWithInt:direction];

        }
        
        
        // if we found food or it's a move forward gene then move forward
        if ( foundFood == 1 || rotation == 1){
            if ( direction == 1 ){
                if ( y < gameBoardHeight - 1 ){
                    ant.position = CGPointMake(currentLocation.x, currentLocation.y + tileSize);
                    ant.fitness = [NSNumber numberWithInt:(ant.fitness.intValue - movePoints)];
                    ant.stepsTaken = [NSNumber numberWithInt:ant.stepsTaken.intValue + 1];

                }
            }else if ( direction == 2 ){
                if ( y > 0 ){
                    ant.position = CGPointMake(currentLocation.x, currentLocation.y - tileSize);
                    ant.fitness = [NSNumber numberWithInt:(ant.fitness.intValue - movePoints)];
                    ant.stepsTaken = [NSNumber numberWithInt:ant.stepsTaken.intValue + 1];

                }
            }else if ( direction == 3 ){
                if ( x < gameBoardWidth - 1 ){
                    ant.position = CGPointMake(currentLocation.x + tileSize, currentLocation.y);
                    ant.fitness = [NSNumber numberWithInt:(ant.fitness.intValue - movePoints)];
                    ant.stepsTaken = [NSNumber numberWithInt:ant.stepsTaken.intValue + 1];

                }
            }else if ( direction == 4 ){
                if ( x > 0 ){
                    ant.position = CGPointMake(currentLocation.x - tileSize, currentLocation.y);
                    ant.fitness = [NSNumber numberWithInt:(ant.fitness.intValue - movePoints)];
                    ant.stepsTaken = [NSNumber numberWithInt:ant.stepsTaken.intValue + 1];

                }
            }
        }
    }];

}





-(int)convertLocationToPosition:(CGPoint )point
{
    float column = point.x/tileSize;
    float row = point.y/tileSize;
    float width = windowSize.width/tileSize;
    
    int location = row * width + column;
    
    return location;
}








@end
