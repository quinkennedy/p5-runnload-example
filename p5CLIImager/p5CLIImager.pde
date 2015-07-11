import java.util.Properties;

Properties props;
int delay = 100;

Properties loadCommandLine () {

  Properties props = new Properties();
  if (args != null) {
    for (String arg : args) {
      String[] parsed = arg.split("=", 2);
      if (parsed.length == 2)
        props.setProperty(parsed[0], parsed[1]);
    }
  }

  return props;
}


void setup () {

  props = loadCommandLine();

  size(400, 200);
  background(0);
  text(props.toString(), 10, 20);  
  text(props.getProperty("text", "No 'text' parameter set."), 10, 40);
  noLoop();
}

void draw() {
  String imageLoc = props.getProperty("image", "");
  background(0);
  noStroke();
  for(int i = 0; i < 100; i++){
    int x = (int)random(0, width);
    int y = (int)random(0, height);
    int r = (int)random(1, 10);
    int c = (int)random(0, 255);
    fill(c);
    ellipse(x, y, r, r);
  }
  if (imageLoc != null && imageLoc.length() > 0){
    save(imageLoc);
    exit();
  }
}