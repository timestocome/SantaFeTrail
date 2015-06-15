//
//  ViewController.m
//  Automata
//
//  Created by Linda Cobb on 5/6/14.
//  Copyright (c) 2014 TimesToCome Mobile. All rights reserved.
//

#import "ViewController.h"
#import "MyScene.h"

@implementation ViewController



-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];

    // Configure the view.
    if ( !_skView.scene ){
        
        SKView * skView = (SKView *)self.view;

        skView.showsFPS = YES;
        skView.showsNodeCount = YES;
    
        // Create and configure the scene.
        SKScene* scene = [MyScene sceneWithSize:skView.bounds.size];
        scene.scaleMode = SKSceneScaleModeFill;
    
        // Present the scene.
        [skView presentScene:scene];
    }
}



- (BOOL)shouldAutorotate
{
    return YES;
}



- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}


- (BOOL)prefersStatusBarHidden {  return YES; }



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

@end
