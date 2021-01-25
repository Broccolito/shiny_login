add_user = function(user_name = "Wanjun Gu",
                    password = ""){
  new_user = tibble(user_name = gsub(pattern = " ",replacement = ".",user_name),
         password = sha256(password))
  write.table(new_user, file = "user_list.txt",append = TRUE, 
              quote = FALSE,row.names = FALSE,sep = ",",
              col.names = FALSE)
}

read_user_list = function(){
  user_list = read.table(file = "user_list.txt",sep = ",")
  names(user_list) = c("user_name", "password_hash")
  user_list$user_name = gsub("[.]",replacement = " ", user_list$user_name)
  return(user_list)
}


