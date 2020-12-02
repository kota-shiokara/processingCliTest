import ikanoshiokara.p5clilib.*;

Cmd c;

String currentDirectory = "C:/"; // directory

String currentWords = ""; // 打ち込んでる文字列
ArrayList<String> log = new ArrayList<String>(); // 表示するログ

float high = 0;

void setup() {
    size(400, 300);
    background(0);
    c = new Cmd(currentDirectory);
    try {
        c.cmd("ls");
    } catch (NullPointerException e) {
        e.printStackTrace();
        log.add("Error: not found \"" + currentDirectory + "\"\n");
    }
    log.add(currentDirectory + " ");
}

void draw() {
    background(0);
    translate(0, high);
    for(int i = 0; i < log.size(); i++){
      String newLine = log.get(i);
      if(i != log.size() - 1) text(newLine, 0, 16 + (14 * i));
      else text(newLine + "$ " + currentWords, 0, 16 + (14 * i));
    }
}

ArrayList<String> parser(String str){
    int cnt = 0;
    int before = 0;
    ArrayList<String> tmp = new ArrayList<String>();
    for(int i = 0; i < str.length() - 1; i++){
        if("\n".equals(str.substring(i,i+1))){
            tmp.add(str.substring(before, i));
            before = i + 2;
            cnt++;
        }else if(i == str.length() - 2){
            tmp.add(str.substring(before, i + 2));
            cnt++;
        }
    }
    return tmp;
}

void keyPressed() {
    if(key != 8) currentWords += key;
    else if(currentWords.length() > 0) currentWords = currentWords.substring(0, currentWords.length()-1);
    if(key == ENTER){
        log.remove(log.size() - 1);
        log.add(c.getCurrentDirectory() + " $ " + currentWords);
        currentWords = currentWords.replace("\n", "");
        if(currentWords.equals("exit")) exit();
        try {
            //log.add(c.cmd(currentWords) + "\n");
            ArrayList<String> tmp = parser(c.cmd(currentWords));
            for(int i = 0; i < tmp.size(); i++){
                log.add(tmp.get(i));
            }
        } catch (NullPointerException e) {
            e.printStackTrace();
        }
        log.add(c.getCurrentDirectory() + " ");
        currentWords = "";
    }
}

// マウスホイールで動かす
void mouseWheel(MouseEvent e){
    high -= e.getAmount() * 18;
    if(high > 0) high = 0;
}