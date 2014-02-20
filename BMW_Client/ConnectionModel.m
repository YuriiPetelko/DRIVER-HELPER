//
//  ConnectionModel.m
//  BMW_Client
//
//  Created by Yurii Petelko on 18.01.14.
//  Copyright (c) 2014 Yurii Petelko. All rights reserved.
//

#import "ConnectionModel.h"
#import <sys/socket.h>
#import <arpa/inet.h>
#import <netinet/in.h>

@interface ConnectionModel ()

@end

@implementation ConnectionModel
-(void)coneectToBMW
{
    int sockfd, portno, n , opt = 1;
    struct sockaddr_in serv_addr;
    struct hostent *server;
    
    char buffer[1024];
    printf("call\n");
    /* Create a socket point */
    sockfd = socket(AF_INET, SOCK_STREAM, 0);
    if (sockfd < 0)
    {
        perror("ERROR opening socket");
        exit(1);
    }
    
    bzero((char *) &serv_addr, sizeof(serv_addr));
    serv_addr.sin_family = AF_INET;
    
    serv_addr.sin_addr.s_addr = inet_addr("172.16.222.1");
    serv_addr.sin_port = htons(67);
    
    /* Now connect to the server */
    if (connect(sockfd,(struct sockaddr*)&serv_addr,sizeof(serv_addr)) < 0)
    {
        perror("ERROR connecting");
        char * error = strerror(errno);
        NSString * err = [NSString stringWithFormat:@"%s", error];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connection failed!"
                                                        message:err
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        
        [alert show];
        //exit(1);
        return ;
    }
    
    /* Now read server response */
    
    n = read(sockfd,buffer,sizeof(buffer));
   
    if (n < 0)
    {
        perror("ERROR reading from socket");
        char * error = strerror(errno);
        NSString * err = [NSString stringWithFormat:@"%s", error];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Receiving data failed!"
                                                        message:err
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        
        [alert show];
        //exit(1);
        return;
    }

    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"You are successfully connected!"
                                                message:@""
                                                delegate:nil
                                    cancelButtonTitle:@"OK"
                                        otherButtonTitles:nil];
        
    [alert show];

}
@end
