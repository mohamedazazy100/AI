#!/bin/bash

echo "****** MAIN LIST ******"
PS3="CHOOSE[1-3]: ";export PS3
select obj in USER GROUP EXIT
do
	case $obj in
#user setting ----------------------------------------------------------------------------------------------
		USER)
			echo "****** LIST OF USER ******"
			PS3="CHOOSE[1-5]: ";export PS3
			select user_obj in ADD_USER  DELETE_USER  SHOW_USER  EDIT_USER  BACK
			do
				case $user_obj in 
					ADD_USER)
						echo "****** LIST OF USER ADD ******"
			                        PS3="CHOOSE[1-3]: ";export PS3
						read -p "ENTER NAME OF USER : " user
						while [[ $user != +([a-zA-Z]) ]]
						do
							echo "PLEASE ENTER VALID NAME"
							read -p "ENTER NAME OF USER : " user
						done
						select add_user in  WITH_DEFAULT_SETTING  WITH_DETAILES  BACK
						do
							case $add_user in
								WITH_DEFAULT_SETTING)
									useradd "$user"
									echo "ENTER PASSWORD OF $user : "
                                                                        passwd "$user"
                                                                       	echo "USER ADDED"
									awk -F : '$1 == "'"$user"'" {print}' /etc/passwd
									break
									;;
								WITH_DETAILES)
									echo "****** LIST OF USER ADD ******"
        			                                       	PS3="CHOOSE[1-5]: ";export PS3
									select user_deltail in 'SHELL'  HOME_DIR  ID  COMMENT  GROUP 
									do
										case $user_deltail in 
											'SHELL')
												read -p "ENTER SHELL OF $USER : " shel 
												useradd -s "$shel" "$user"
												echo "ENTER PASSWORD OF $user : "
                                                                                                passwd "$user"					
												echo "USER ADDED"      	
												awk -F : '$1 == "'"$user"'" {print}' /etc/passwd;break 2
												;;
											HOME_DIR)
												read -p "ENTER HOME DIRECTORY OF $USER : " home
                                                                                               	useradd -md "$home" "$user" 2> /dev/null
												echo "ENTER PASSWORD OF $user : "
												passwd "$user"
                                                                                               	echo "USER ADDED"
                                                                                               	awk -F : '$1 == "'"$user"'" {print}' /etc/passwd;break 2
												;;
											ID)
												read -p "ENTER ID OF $USER : " id
                                                                                               	useradd -u "$id" "$user"
												echo "ENTER PASSWORD OF $user : "
                                                                                                passwd "$user"
                                                                                               	echo "USER ADDED"
                                                                                               	awk -F : '$1 == "'"$user"'" {print}' /etc/passwd;break 2
												;;
											COMMENT)
												read -p "ENTER COMMENT OF $user : " comment
												useradd -c "$comment" "$user"
												echo "ENTER PASSWORD OF $user : "
                                                                                                passwd "$user"
												echo "USER ADDED"
                                                                                                awk -F : '$1 == "'"$user"'" {print}' /etc/passwd;break 2
												;;
											GROUP)
												read -p "ENTER GROUP OF $user : " group
												select type_group in PRIMARY  SECONDARY
												do
													case $type_group in 
														PRIMARY)
															useradd -g "$group" "$user"
															echo "ENTER PASSWORD OF $user : "
                                                                                                			passwd "$user"
															echo "USER ADDED"
        		                                                                                        	awk -F : '$1 == "'"$group"'" {print}' /etc/passwd;break 3
															;;
														SECONDARY)											              						      	      useradd -G "$group" "$user"
															echo "ENTER PASSWORD OF $user : "
                                                                                                			passwd "$user"
                                                                                                                       	echo "USER ADDED"
                                                                                                                        awk -F : '$1 == "'"$group"'" {print}' /etc/passwd;break 3
															;;
														*)echo "ENTER VAILD NUMBER [1-3]"
													esac
												done;;
											*)echo "ENTER VAILD NUMBER FROM [1-5]";;
										esac		
									done;;
								BACK)PS3="CHOOSE[1-5]: ";export PS3;break;;
								*)echo "ENTER VALID NUMBER [1-3]";;		
							esac	
						done
				
						;;
					DELETE_USER)
						PS3="CHOOSE[1-2]: ";export PS3
						read -p "ENTER NAME OF USER : " user
                                                while [[ $user != +([a-zA-Z]) ]]
                                                do
                                                	echo "PLEASE ENTER VALID NAME"
                                                        read -p "ENTER NAME OF USER : " user
                                                done

						select user_del in  DELETE_USER  DELETE_USER_HOME_DIR 
						do
							case $user_del in
								DELETE_USER)
									userdel "$user"
									echo "USER DELETED"
									PS3="CHOOSE[1-2]: ";export PS3
									break;;
								DELETE_USER_HOME_DIR)
									userdel -r "$user"
									echo "USER DELETED"
									PS3="CHOOSE[1-2]: ";export PS3
									break;;
								*)echo "ENTER VALID NUMBER [1-3]";;
							esac
						done
						;;
					SHOW_USER)
						awk -F: '$3 >= 1000{print "(USER) : "$1" ** (ID) : "$3" ** (HOME) : "$6 " ** (SHELL) : "$7}'  /etc/passwd
						break
						;;
					EDIT_USER)
						PS3="CHOOSE[1-13]: ";export PS3
						read -p "ENTER USER NAME: " user
						while [[ $user != +([a-zA-Z]) ]]
						do
						    echo "PLEASE ENTER VALID NAME"
						    read -p "ENTER USER NAME: " user
						done

						select edit_user in \
						    ADD_TO_GROUP REMOVE_FROM_GROUP CHANGE_ID CHANGE_UMASK CHANGE_PASSWD \
						    LOCK_USER CHANGE_SHELL ADD_COMMENT CHANGE_MAX_DAYS CHANGE_MIN_DAYS \
						    CHANGE_EXPIRE_DATE CHANGE_WARNING_DAYS CHANGE_INACTIVE_DAYS BACK
						do
						    case $edit_user in
						        ADD_TO_GROUP)
						            read -p "ENTER GROUP NAME: " group
						            select group_type in PRIMARY SECONDARY
						            do
						                case $group_type in
						                    PRIMARY)
						                        usermod -g "$group" "$user"
						                        echo "PRIMARY GROUP CHANGED"
						                        break;;
						                    SECONDARY)
						                        usermod -aG "$group" "$user"
						                        echo "USER ADDED TO SECONDARY GROUP"
						                        break;;
						                    *)printf "ERROR >> Please Enter Valid Number[1-2]\nTRY AGAIN....\n";;
						                esac
						            done
						            ;;
						        REMOVE_FROM_GROUP)
						            read -p "ENTER GROUP NAME: " group
						            gpasswd -d "$user" "$group"
						            echo "USER REMOVED FROM GROUP"
						            ;;
						        CHANGE_ID)
						            read -p "ENTER NEW UID: " id
						            usermod -u "$id" "$user"
						            echo "USER ID CHANGED"
						            ;;
						        CHANGE_UMASK)
						            read -p "ENTER NEW UMASK: " mask
						            echo "umask $mask" >> "$(awk -F: '$1==\"'"$user"'\" {print $6}' /etc/passwd)/.bashrc"
						            echo "UMASK UPDATED"
						            ;;
						        CHANGE_PASSWD)
						            passwd "$user"
						            ;;
						        LOCK_USER)
						            usermod -L "$user"
						            echo "USER LOCKED"
						            ;;
						        CHANGE_SHELL)
						            read -p "ENTER NEW SHELL: " shel
						            usermod -s "$shel" "$user"
						            echo "SHELL UPDATED"
						            ;;
						        ADD_COMMENT)
						            read -p "ENTER COMMENT: " comment
						            usermod -c "$comment" "$user"
						            echo "COMMENT UPDATED"
						            ;;
						        CHANGE_MAX_DAYS)
						            read -p "ENTER MAX DAYS: " days
						            chage -M "$days" "$user"
						            echo "MAX DAYS UPDATED"
						            ;;
						        CHANGE_MIN_DAYS)
						            read -p "ENTER MIN DAYS: " days
						            chage -m "$days" "$user"
						            echo "MIN DAYS UPDATED"
						            ;;
						        CHANGE_EXPIRE_DATE)
						            read -p "ENTER EXPIRE DATE (YYYY-MM-DD): " date
						            chage -E "$date" "$user"
						            echo "EXPIRE DATE UPDATED"
						            ;;
						        CHANGE_WARNING_DAYS)
						            read -p "ENTER WARNING DAYS: " days
						            chage -W "$days" "$user"
						            echo "WARNING DAYS UPDATED"
						            ;;
						        CHANGE_INACTIVE_DAYS)
						            read -p "ENTER INACTIVE DAYS: " days
						            chage -I "$days" "$user"
						            echo "INACTIVE DAYS UPDATED"
						            ;;
						        BACK)
						            PS3="CHOOSE[1-5]: ";export PS3
						            break;;
						        *)
						            printf "ERROR >> Please Enter Valid Number[1-13]\nTRY AGAIN....\n";;
						    esac
						done
						;;
					BACK)PS3="CHOOSE[1-3]: ";export PS3;break;;
					*)printf "ERROR >> Please Enter Valid Number From[1-5]\nTRY AGAIN....\n";;
				esac
			done;;
		
#group setting ----------------------------------------------------------------------------------------------
		GROUP)
			echo "****** LIST OF GROUP ******"
			PS3="CHOOSE[1-5]: ";export PS3
                        select group_obj in ADD DELETE SHOW EDIT BACK
                        do
                                case $group_obj in
				#add group ***************************
                                        ADD)
					echo "***** LIST ADD GROUP *****"
					PS3="CHOOSE[1-3]: ";export PS3
					select add_group in ADD_SPEC_ID ADD_DEFAULT_ID BACK
					do
						case $add_group in 
						ADD_DEFAULT_ID)
							read -p "Enter group: " group
							groupadd "$group"
							echo "GROUP ADDED";;
						ADD_SPEC_ID)
							read -p "Enter group name: " group
							read -p "Enter group ID: " id
                                                        groupadd -g "$id" "$group"
                                                        echo "GROUP ADDED";;
						BACK)PS3="CHOOSE[1-3]: ";export PS3;break;;
						*)printf "ERROR >> Please Enter Valid Number[1-3]\nTRY AGAIN....\n";;
		                                esac
					done;;
				#delete group ************************
                                        DELETE)
					read -p "Enter group: " group
					groupdel -f "$group"
					echo "GROUP DELETED"
					;;
				#show group **************************
                                        SHOW)
					echo "***** SHOW GROUPS *****"
					PS3="CHOOSE[1-5]: ";export PS3
					select show_group in SHOW_GROUP_WITH_ID SHOW_GROUP_WITH_NAME SHOW_ALL_GROUPS SHOW_USERS_IN_SPEC_GROUP  BACK 
                                        do
                                                case $show_group in
						
                                                	SHOW_GROUP_WITH_ID)
                                                        	read -p "Enter group: " group
                                                        	awk -F : '{print "group: " $1" --- group id >> " $3}' /etc/group | grep "$group"
                                                        	;;
                                                	SHOW_GROUP_WITH_NAME)
                                                        	read -p "Enter group name: " group
                                                       		awk -F : '{print "group: " $1" --- group id >> " $3}' /etc/group | grep "$group"
                                                        	;;
							SHOW_ALL_GROUPS)
								awk -F : '$3 >= 1000 && $3 <= 60000{print "group: " $1" --- group id >> " $3}' /etc/group;;
							SHOW_USERS_IN_SPEC_GROUP)
								read -p "Enter group name: " group
								getent group "$group" | awk -F ":" '{print $4}' | awk -F "," '{print $0}'
								;;
                                                	BACK)PS3="CHOOSE[1-5]: ";export PS3;break;;
                                                	*)printf "ERROR >> Please Enter Valid Number[1-5]\nTRY AGAIN....\n";;
                                                esac
                                        done
					;;
				#edit group **************************
                                        EDIT)
					PS3="CHOOSE[1-5]: ";export PS3
					select edit_group in CHANGE_ID CHANGE_GROUP_NAME ADD_USER_TO_GROUP EXIT_USER_FROM_GROUP BACK
					do
						case $edit_group in 
							CHANGE_ID)
								read -p "Enter group name: " group
								read -p "Enter new group ID: " id
								groupmod -g "$id" "$group"
								echo "EDIT IS DONE"
								grep "$group" /etc/group | awk -F : '{print $1 "---> "$3}'
								;;
							CHANGE_GROUP_NAME)
								read -p "Enter old group name: " group
								read -p "Enter new group name: " new_group
								groupmod -n "$new_group" "$group"
								awk -F : '{print "group: " $1" --- group id >> " $3}' /etc/group | grep "$new_group"
								;;
							ADD_USER_TO_GROUP)
								read -p "Enter group name: " group
                                                                read -p "Enter user you want to add in $group group: " user
								usermod -aG "$group" "$user"
								echo "USER $user ADDED TO $group group"
								id "$user"
								;;	
							EXIT_USER_FROM_GROUP)
								read -p "Enter group name: " group
                                                                read -p "Enter user you want to remove it from *$group* group: " user
								gpasswd -d "$user" "$group"
								echo "USER "$user" DELETED FROM "$group""
								id "$user"
								;;
							BACK)PS3="CHOOSE[1-5]: ";export PS3;break;;
							*)printf "ERROR >> Please Enter Valid Number[1-5]\nTRY AGAIN....\n"
						esac
					done   
					;;

				#back group **************************
                                        BACK)PS3="CHOOSE[1-3]: ";export PS3;break;;
                                        *)printf "ERROR >> Please Enter Valid Number[1-5]\nTRY AGAIN....\n";;
                                esac
                        done;;

#exit setting ------------------------------------------------------------------------------------------------
		EXIT)echo "**** THANKS ****";break;;

		*)printf "ERROR >> Please Enter Valid Number From[1-3]\nTRY AGAIN....\n"
	esac
done
