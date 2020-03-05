#!/bin/bash

diff_res()
{
	DIFF=$(diff $1 $2)
	if [ "$DIFF" == "" ] ; then
 		echo -ne "\033[0;32m \xE2\x9C\x94	\033[0m"
		let "k += 1"
		# rm -rf yours/test$i.txt real/test$i.txt
	else
 		echo -ne "\033[0;31m x	\033[0m"
		echo -n "Test $i : " >> diff.txt
		echo $TMP >> diff.txt
		echo $MINISHELL >> diff.txt
		echo >> diff.txt
		echo "$DIFF" >> diff.txt
		echo >> diff.txt
		echo "<<>><<>><<>><<>><<>><<>><<>><<>><<>><<>><<>><<>><<>><<>><<>>" >> diff.txt
		echo "<<>><<>><<>><<>><<>><<>><<>><<>><<>><<>><<>><<>><<>><<>><<>>" >> diff.txt
		echo >> diff.txt
	fi
	let "i += 1"
}

PROJECT_PATH=".."
rm -rf real yours minishell diff.txt srcs/bash_tests.txt
mkdir real yours
make -C $PROJECT_PATH
cp $PROJECT_PATH/minishell .
cp srcs/minishell_tests.txt srcs/bash_tests.txt
sed -i -e "s/yours/real/g" srcs/bash_tests.txt
sed -i -e "s/.\/minishell/bash/g" srcs/bash_tests.txt
rm -rf srcs/bash_tests.txt-e
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
	if [ $i -lt 10 ] ; then
		echo -n "Test   $i :"
	elif [ $i -lt 100 ] ; then
		echo -n "Test  $i :"
	else
		echo -n "Test $i :"
	fi
	BASH=$(sed -n ${i}p srcs/bash_tests.txt)
	MINISHELL=$(sed -n ${i}p srcs/minishell_tests.txt)
	echo $BASH | bash >> real/test$i.txt
	echo $MINISHELL | bash >> yours/test$i.txt
	diff_res "real/test$i.txt" "yours/test$i.txt"
	TMP=$(sed -n ${i}p srcs/test_name.txt)
	let "j = ($i - 1) % 10"
	if [ $j -eq 0 ] ; then
		echo
	fi
done
echo
rm -rf real/tmp*.txt yours/tmp*.txt minishell
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
