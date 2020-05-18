#!/bin/bash

printall()
{
	index=${2}
	while [ -f ${1}${index}.txt ]
	do
		print_test_nb $index
		echo
		cat ${1}${index}.txt
		echo "
		"
		let "index += 1"
	done

}

print_test_nb()
{
	if [ $1 -lt 10 ] ; then
		echo -n "Test   $1 :"
	elif [ $1 -lt 100 ] ; then
		echo -n "Test  $1 :"
	else
		echo -n "Test $1 :"
	fi
}

diff_res()
{
	DIFF=$(diff $1 $2)
	if [ "$DIFF" == "" ] ; then
 		echo -ne "\033[0;32m \xE2\x9C\x94	\033[0m" # // WELL DONE -> PRINT CHECK //
		let "k += 1"
		rm -rf yours/test$i.txt real/test$i.txt
	else
 		echo -ne "\033[0;31m x	\033[0m" # // NOT GOOD -> PRINT CROSS & WRITE DIFF //
		echo "Test $i : $NAME_TEST
$MINISHELL

$DIFF

<<>><<>><<>><<>><<>><<>><<>><<>><<>><<>><<>><<>><<>><<>><<>>
<<>><<>><<>><<>><<>><<>><<>><<>><<>><<>><<>><<>><<>><<>><<>>
" >> diff.txt
	fi
	let "i += 1"
}

norminette_test()
{
	NORMINETTE_LIST=$(~/.norminette/norminette.rb $PROJECT_PATH | grep -v "Warning: Not a valid file" | wc -l) # // ABSOLUTE PATH FOR NORMINETTE - ALIAS NOT WORKING //
	FILE_LIST=$(find $PROJECT_PATH -type f -not -path '*/\.*' | wc -l)
	let "norminette_res = $FILE_LIST - $NORMINETTE_LIST"
	if [ $norminette_res -eq 0 ] ; then
 		echo -e "\033[0;32m \xE2\x9C\x94	\033[0m" # // NORMINETTE OK -> PRINT CHECK //
	else
 		echo -e "\033[0;31m x	\033[0m" # // BAD NORMINETTE -> PRINT CROSS //
		echo -e "\033[0;31m There might be a norm error, please check by yourself	\033[0m"
	fi
}

create_bash_aliases() # // JUST FOR VM MODE - NOT WORKING FOR THE MOMENT ANYWAY //
{
	if [ -f ~/.bash_aliases ]; then
    	cp ~/.bash_aliases srcs/bash_aliases_recovery
	fi
	echo "alias norminette=\"~/.norminette/norminette.rb\"" >> ~/.bash_aliases
	echo "alias gcc=\"clang-9\"" >> ~/.bash_aliases
	echo "alias clang=\"clang-9\"" >> ~/.bash_aliases
	source ~/.bashrc
}

PROJECT_PATH=".." # // CHANGE PROJECT PATH HERE //
																													# create_bash_aliases
rm -rf real yours minishell diff.txt srcs/test1 srcs/test2 srcs/test3																				# srcs/bash_tests.txt
mkdir real yours
make -C $PROJECT_PATH
cp $PROJECT_PATH/minishell .
# make -C $PROJECT_PATH fclean
																													# cp srcs/minishell_tests.txt srcs/bash_tests.txt
																													# sed -i -e "s/yours/real/g" srcs/bash_tests.txt
																													# sed -i -e "s/.\/minishell/bash/g" srcs/bash_tests.txt
																													# rm -rf srcs/bash_tests.txt-e

cd srcs ; mkdir test1 test2 test3 # // PREPARATION FOR EXECUTABLE PATH ORDER TESTS //
clang-9 printbonjour.c -o  testexecpath ; mv testexecpath test1
clang-9 printhello.c -o testexecpath ; mv testexecpath test2
clang-9 printbomdia.c -o testexecpath ; mv testexecpath test3
cd ..

echo
echo "=========================================="
echo "============== MINISHELL ================="
echo "=========================================="
echo

echo -n "NORMINETTE : "
norminette_test # // COMMENT THIS LINE IF YOU DON'T WANT NORMINETTE //

echo
echo "coucou" > srcs/anti_cheat_diff.txt
echo "$HOME" >> srcs/anti_cheat_diff.txt
env | grep ^HOME= >> srcs/anti_cheat_diff.txt
echo -n "ANTI-CHEAT TEST : "
./minishell < srcs/anticheat.txt >> yours/anticheat.txt
cat yours/tmp_cheat.txt | grep ^HOME= >> yours/anticheat.txt
TMP="CHEAT TEST"
MINISHELL=$(cat srcs/anticheat.txt)
diff_res "yours/anticheat.txt" "srcs/anti_cheat_diff.txt"

i=1
k=0
echo -e "

VALID COMMAND TESTS : 
"
NAME_TEST=$(sed -n ${i}p srcs/test_name.txt)
while [ "$NAME_TEST" != "" ]
do
	print_test_nb $i
	BASH=$(sed -n ${i}p srcs/bash_tests.txt)
	MINISHELL=$(sed -n ${i}p srcs/minishell_tests.txt)
	echo $BASH | bash >> real/test$i.txt
	echo $MINISHELL | bash >> yours/test$i.txt
	diff_res "real/test$i.txt" "yours/test$i.txt"
	NAME_TEST=$(sed -n ${i}p srcs/test_name.txt)
	let "j = ($i - 1) % 10"
	if [ $j -eq 0 ] ; then
		echo
	fi
done
m=$i
echo "

ERROR TESTS : 
"
l=1
NAME_TEST=$(sed -n ${1}p srcs/test_name_error.txt)
while [ "$NAME_TEST" != "" ]
do
	print_test_nb $i
	touch real/test_error$i.txt yours/test_error$i.txt
	BASH=$(sed -n ${l}p srcs/bash_tests_error.txt ; echo "echo \$?")
	MINISHELL=$(sed -n ${l}p srcs/minishell_tests_error.txt ; echo "echo \$?")
	echo $BASH | bash 1> real/test$i.txt 2>> real/test_error$i.txt
	echo $MINISHELL | ./minishell 1> yours/test$i.txt 2>> yours/test_error$i.txt
	diff_res "real/test$i.txt" "yours/test$i.txt"
	let "i -= 1"
	ERR_BASH=$(cat real/test_error$i.txt)
	ERR_MINISHELL=$(cat yours/test_error$i.txt)
	let "i += 1"
																													# echo $ERR_BASH
	let "l += 1"
	NAME_TEST=$(sed -n ${l}p srcs/test_name_error.txt)
	let "j = ($l - 1) % 10"
	if [ $j -eq 0 ] ; then
		echo
	fi
done

echo -e "\033[0;90m

HARDCORE TESTS (NOT SPRECIFICALLY ASKED FOR CORRECTION) : \033[0m
"
l=1
NAME_TEST=$(sed -n ${l}p srcs/test_name_hard.txt)
while [ "$NAME_TEST" != "" ]
do
	echo -ne "\033[0;90m"
	print_test_nb $i
	echo -ne "\033[0m"
	BASH=$(sed -n ${l}p srcs/bash_tests_hard.txt)
	MINISHELL=$(sed -n ${l}p srcs/minishell_tests_hard.txt)
	echo $BASH | bash >> real/test$i.txt
	echo $MINISHELL | bash >> yours/test$i.txt
	diff_res "real/test$i.txt" "yours/test$i.txt"
	let "l += 1"
	NAME_TEST=$(sed -n ${l}p srcs/test_name_hard.txt)
	let "j = ($l - 1) % 10"
	if [ $j -eq 0 ] ; then
		echo
	fi
done

echo
echo

																											# printall yours/test 1

rm -rf real/tmp*.txt yours/tmp*.txt yours/anticheat.txt srcs/test1 srcs/test2 srcs/test3 minishell
if [ -f srcs/bash_aliases_recovery ]; then
    mv srcs/bash_aliases_recovery ~/.bash_aliases
fi
let "i -= 1"
if [ $i -eq $k ] ; then
 		echo -ne "
             !         !          
            ! !       ! !          
           ! . !     ! . !          
              ^^^^^^^^^ ^            
            ^             ^          
          ^  (0)       (0)  ^       
         ^        ""         ^       
        ^   ***************    ^     
      ^   *                 *   ^    
     ^   *   /\   /\   /\    *    ^   
    ^   *                     *    ^
   ^   *   /\   /\   /\   /\   *    ^     \033[0;32m $k / $i : Well done ! \033[0m
  ^   *                         *    ^
  ^  *                           *   ^
  ^  *                           *   ^
   ^ *                           *  ^  
    ^*                           * ^ 
     ^ *                        * ^
     ^  *                      *  ^
       ^  *       ) (         * ^
           ^^^^^^^^ ^^^^^^^^^ 
"
	else
 		echo -ne "
     .... NO! ...                  ... MNO! ...
   ..... MNO!! ...................... MNNOO! ...
 ..... MMNO! ......................... MNNOO!! .
.... MNOONNOO!   MMMMMMMMMMPPPOII!   MNNO!!!! .
 ... !O! NNO! MMMMMMMMMMMMMPPPOOOII!! NO! ....
    ...... ! MMMMMMMMMMMMMPPPPOOOOIII! ! ...
   ........ MMMMMMMMMMMMPPPPPOOOOOOII!! .....
   ........ MMMMMOOOOOOPPPPPPPPOOOOMII! ...
    ....... MMMMM..    OPPMMP    .,OMI! ....
     ...... MMMM::   o.,OPMP,.o   ::I!! ...
         .... NNM:::.,,OOPM!P,.::::!! ....      \033[0;31m $k / $i : Try Again ! \033[0m
          .. MMNNNNNOOOOPMO!!IIPPO!!O! .....    \033[0;31m    Check diff.txt \033[0m
         ... MMMMMNNNNOO:!!:!!IPPPPOO! ....
           .. MMMMMNNOOMMNNIIIPPPOO!! ......
          ...... MMMONNMMNNNIIIOO!..........
       ....... MN MOMMMNNNIIIIIO! OO ..........
    ......... MNO! IiiiiiiiiiiiI OOOO ...........
  ...... NNN.MNO! . O!!!!!!!!!O . OONO NO! ........
   .... MNNNNNO! ...OOOOOOOOOOO .  MMNNON!........
   ...... MNNNNO! .. PPPPPPPPP .. MMNON!........
      ...... OO! ................. ON! .......
         ................................
"
	fi
