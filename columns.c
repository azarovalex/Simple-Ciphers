//
//  columns.c
//  Theory Of Information, Lab 1
//
//  Created by Alex Azarov on 21/09/2017.
//  Copyright © 2017 Alex Azarov. All rights reserved.
//
#include <stdlib.h>
#include <string.h>
#include <printf.h>

static int arr[100];
static char collumns[5000];

const char *ColumnEncipher(const char *plaintext, const char *keyword) {
    int keywordLen = (int) strlen(keyword);
    int plaintextLen = (int) strlen(plaintext);

    int sizeX = plaintextLen / keywordLen;
    if (plaintextLen % keywordLen)
        sizeX += 1;
    
    char matrix[sizeX][keywordLen];
    
    for (int i = 0, k = 0; i < sizeX; i++) {
        for (int j = 0; j < keywordLen; j++) {
            if (plaintext[k] == '\0') {
                matrix[i][j] = '_';
            } else {
                matrix[i][j] = plaintext[k];
            }
            k++;
        }
    }
    
    char temp;
    int  pos;
    
    for (int i = 0; i < keywordLen; i++)
        arr[i] = -1;
    
    for (int i = 0; i < keywordLen; i++) {
        temp = '~';
        pos = 0;
        
        for (int j = 0; j < keywordLen; j++) {
            if (temp > keyword[j] && arr[j] == -1) {
                temp = keyword[j];
                pos = j;
            }
            
        }
        arr[pos] = i;
    }
    
    char *ciphertext = malloc(plaintextLen + 1);
    int index = 0;
    
    for (int i = 0; i < keywordLen; i++) {
        int j;
        for (j = 0; j < keywordLen; j++) {
            if (arr[j] == i) {
                break;
            }
        }
        for (int k = 0; k < sizeX; k++) {
            if (matrix[k][j] != '_') {
                ciphertext[index++] = matrix[k][j];
            }
        }
    }
    ciphertext[index] = '\0';


    return ciphertext;
    
    
}
