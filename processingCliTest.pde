import ikanoshiokara.p5clilib.*;

Cmd c;

String currentDirectory = "C:/"; // directory

String log = ""; // 表示するログ
String currentWords = ""; // 打ち込んでる文字列

void setup() {
    size(400, 300);
    background(0);
    c = new Cmd(currentDirectory);
    try {
        c.ls();
    } catch (NullPointerException e) {
        e.printStackTrace();
        log += "Error: not found \"" + currentDirectory + "\"\n";
    }
    log += currentDirectory + " ";
}

void draw() {
    background(0);
    text(log + "$ " + currentWords, 0, 16);
}

void keyPressed() {
    if(key != 8) currentWords += key;
    else if(currentWords.length() > 0) currentWords = currentWords.substring(0, currentWords.length()-1);
    if(key == ENTER){
        log += "$ " + currentWords;
        if(currentWords.replace("\n", "").equals("ls")){
            try {
                log += c.ls() + "\n";
            } catch (NullPointerException e) {
                e.printStackTrace();
            }
        }
        log += currentDirectory + " ";
        currentWords = "";
    }
}
