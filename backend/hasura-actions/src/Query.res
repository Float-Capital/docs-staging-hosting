module CreateUser = %graphql(`
    mutation createUser($object: user_insert_input!) {
        insert_user_one(object: $object){
            ethAddress
            userName
        }
    }
`)