#!/bin/bash

diff_res()
{
	echo ""
	DIFF=$(diff $1 $2)
	if [ "$DIFF" == "" ] ; then
 		echo -e "\033[0;32m[OK]\033[0m"
		let "k += 1"
	else
 		echo -e "\033[0;31m[KO]\033[0m"
		echo "---------- Test $i : ----------" >> diff.txt
		echo >> diff.txt
		echo $MINISHELL ":" >> diff.txt
		echo >> diff.txt
		echo "$DIFF" >> diff.txt
		echo >> diff.txt
	fi
	let "i += 1"
	echo ""
}

PROJECT_PATH=".."
rm -rf real yours minishell diff.txt
mkdir real yours
make -C $PROJECT_PATH
cp $PROJECT_PATH/minishell .
echo ""
echo "=========================================="
echo "============== MINISHELL ================="
echo "=========================================="
echo ""
i=1
k=0
TMP=$(sed -n ${i}p srcs/test_name.txt)
while [ "$TMP" != "" ]
do
	echo -n "Test $i : "
	echo $TMP
	BASH=$(sed -n ${i}p srcs/bash_tests.txt)
	MINISHELL=$(sed -n ${i}p srcs/minishell_tests.txt)
	echo $BASH | bash >> real/test$i.txt
	echo $MINISHELL | bash >> yours/test$i.txt
	diff_res "real/test$i.txt" "yours/test$i.txt"
	TMP=$(sed -n ${i}p srcs/test_name.txt)
done

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
          .. MMNNNNNOOOOPMO!!IIPPO!!O! .....
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
