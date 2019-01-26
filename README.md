# LACD_FinalProject_Verilog
- I recurrent a game named "Flappy Bird" in this project.
- This project using verilog based on the xilinx's Kintex-7, which is integrated into the SWORD platform. Besides, the whole project uses ISE 14.7, so you may pay attention to the .UCF file.
- This game uses VGA(RGB444) to show pictures, 7-segments digital LEDs to show scores, buzzer to play music("I want to fly") when playing games, one array keyboard to reset the whole game, arduino's LEDs being on when died, arduino's four-bits digital LEDs to show game times, and P2S keyboard to control the bird('W'-up, 'P'-pause, and so on). These functional components are located on SWORD.
- This project is a final homework for my course named Logic and Circuit Design.
- This project is finished by myself, and if you are the student of ZJU, please not just copy it and submit it to your teacher, because  teacher may check the similarity. Except for it, if you can understand how VGA and P2S are used by reading my code, I will be very happy. Maybe I will write a blog on the CSDN.
- For some reasons, I won't give the data of ROM and RAM.
- Code file named 'top.v' is the most important file, and all functions are implemented there.
- Game still have some bugs, you can fix it up if you are interested in it.
