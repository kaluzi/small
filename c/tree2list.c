#include "tree2list.h"
#include <stdlib.h>
#include <assert.h>

struct node *tree2list(struct node *root) {
  if (root == NULL) return NULL;
  if (root->right == NULL && root->left == NULL){
    root->right = root;
    root->left = root;
    return root;
  }else if (root->right == NULL){
    struct node *lst_left = tree2list(root->left);
    root->left = lst_left->left;
    root->right = lst_left;
    lst_left->left->right = root;
    lst_left->left = root;
    return lst_left;
  }else if (root->left == NULL){
    struct node *lst_right  = tree2list(root->right);
    root->right = lst_right;
    root->left = lst_right->left;
    lst_right->left->right = root;
    lst_right->left = root;
    return root;
  }else{
    struct node *lst_right  = tree2list(root->right);
    struct node *lst_left = tree2list(root->left);
    root->right = lst_right;
    root->left = lst_left->left;
    lst_right->left->right = lst_left;
    lst_left->left->right = root;
    lst_left->left = lst_right->left;
    lst_right->left = root;
    return lst_left;
  }
}
