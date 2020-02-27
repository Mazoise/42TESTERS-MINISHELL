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
		echo "----------Test $i : ----------" >> diff.txt
		echo >> diff.txt
		echo "$DIFF" >> diff.txt
		echo >> diff.txt
	fi
	let "i += 1"
	echo ""
}

rm -rf real yours minishell diff.txt
mkdir real yours
make -C ..
cp ../minishell .
echo ""
echo "=========================================="
echo "============== MINISHELL ================="
echo "=========================================="
echo ""
i=1
k=0
echo "Test $i : Echo and >"
echo "echo hello" | bash > real/test$i.txt
echo "echo hello" | ./minishell > yours/test$i.txt
diff_res "real/test$i.txt" "yours/test$i.txt"

echo "Test $i : Rights for >"
ls -la real | grep test1.txt | cut -c-10 > real/test$i.txt
ls -la yours | grep test1.txt | cut -c-10 > yours/test$i.txt
diff_res "real/test$i.txt" "yours/test$i.txt"

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
# export LALA=coucou
# env
# cd ..
# pwd
# echo $LALA >> file2
# echo coucou | bash
