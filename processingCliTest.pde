import ikanoshiokara.p5clilib.*;

Cmd c;

String currentDirectory = "C:/"; // directory

String currentWords = ""; // 打ち込んでる文字列
ArrayList<String> log = new ArrayList<String>(); // 表示するログ

float high = 0; // Height of text show
int photo = 0; // Number of image save
boolean isRecord = false; // Record switch

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
    if(isRecord){
        saveFrame("frames/####.png");
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
    if(key != 8 && keyCode != SHIFT) currentWords += key;
    else if(currentWords.length() > 0 && key == 8) currentWords = currentWords.substring(0, currentWords.length()-1);
    if(key == ENTER){
        log.remove(log.size() - 1);
        log.add(c.getCurrentDirectory() + " $ " + currentWords);
        currentWords = currentWords.replace("\n", "");
        if(currentWords.equals("exit")) exit();
        else if(currentWords.equals("startRecord")) {
            isRecord = true;
            println("StartRecord");
        }
        else if(currentWords.equals("endRecord")){
            isRecord = false;
            println("EndRecord");
        }
        else if(currentWords.equals("save")) {
            save("frame/" + photo + ".png");
            photo++;
        }
        else if(currentWords.indexOf(" ") != -1){
            String arr = currentWords.substring(currentWords.indexOf(" ") + 1, currentWords.length());
            currentWords = currentWords.substring(0, currentWords.indexOf(" "));
            try {
                println(currentWords + "\n" + arr);
                ArrayList<String> tmp = parser(c.cmd(currentWords, arr));
                for(int i = 0; i < tmp.size(); i++){
                    log.add(tmp.get(i));
                }
            } catch (NullPointerException e) {
                e.printStackTrace();
            }
        }else{
            try {
                ArrayList<String> tmp = parser(c.cmd(currentWords));
                for(int i = 0; i < tmp.size(); i++){
                    log.add(tmp.get(i));
                }
            } catch (NullPointerException e) {
                e.printStackTrace();
            }
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