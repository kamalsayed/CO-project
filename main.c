#include <stdio.h>
#include <stdlib.h>
int BubbleSort_both(int *array , int type, int size);
int search_(int *array,int key ,int size);

int main()
{
    int array[15]={5,7,8,2,9,1,4,15,3,10,11,12,13,14,6};
    int search =0;
    int sort=-1;
    int s = sizeof(array)/sizeof(array[0]);
    int key;
    int i;
    printf("for search Enter 1 , for sort enter 0\n");
    scanf("%d",&search);
    if(search == 1){
        printf("Enter the Value you are searching for\n");
        scanf("%d",&key);
        if(search_(&array,key,s))
            printf("Exist\n");
        else
            printf("not Exist\n");
    }else{
    printf("for ascending sort enter 0 for descending sort enter 1\n");
    scanf("%d",&sort);
    if(sort == 0 || sort == 1 ){
        //ascending or descending
        BubbleSort_both(&array,sort,s);
        for(i=0;i<s;i++){
            printf("%d . %d \n",i+1,array[i]);
        }
    }
    else{
        printf(" invalid input ");
    }

    }
    return 0;
}


int BubbleSort_both(int *array , int type, int size){

    int i ,j,tmp ;
    for(i=0;i<size-1;i++){ //i=5

        for(j=0;j<size-1-i;j++){//0--->14-5 : 9

            if(array[j]>array[j+1]){
                tmp = array[j];
                array[j]=array[j+1];
                array[j+1]=tmp;
            }
        }//nested
    }//outer

   if (type == 0){
    return;
   }
   else if(type==1){
    for(i=0,j = size-1;i<(size-1)/2;i++, j--){
        tmp = array[j]; // from last indexes in  the array
        array[j]=array[i];
        array[i]=tmp;
    }
   }
    //end of descending
}

int search_(int *array,int key ,int size){
int i;
for(i=0;i<size;i++){
    if(key == array[i]){
        return 1;
    }
}
return 0;
}
