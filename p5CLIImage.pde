String processingJavaPath = "/media/quin/data/appsubu/processing-3.0a10/processing-java";

Process currProcess;
String imageLoc;
String sketchDir;
String command;
String compile;
PImage img;
String errorMsg = "";

State currState = State.compile;

enum State{
  compile,
  run,
  loadImage,
  display,
  error
}

void setup () {
  size(400,400);
  initCommands();
}

void initCommands(){
  String dataDir = dataPath("");
  sketchDir = dataDir.substring(0, dataDir.lastIndexOf("/data")+1);
  imageLoc = dataPath("image"+((int)random(0,10000))+".png");
  command = sketchDir + "build/p5CLIImager "+
"image="+imageLoc;
  compile =
processingJavaPath +" "+
"--export --no-java --force --sketch="+sketchDir+"p5CLIImager "+
"--output="+sketchDir+"build/";
}

void draw() {
  background(255);
  fill(0);
  if (currState == State.compile){
    if (currProcess == null){
      try{
        currProcess = Runtime.getRuntime().exec(compile);
      } catch(IOException ioe){
        errorMsg = ioe.getMessage();
        currState = State.error;
      }
    }
    if (currProcess != null){
      try{
        int exitVal = currProcess.exitValue();
        if (true || exitVal == 0){
          currProcess = null;
          currState = State.run;
        } else {
          errorMsg = "compiling exited with code " + exitVal;
          currState = State.error;
        }
      } catch(IllegalThreadStateException itse){
        //exception gets thrown until process exits
      }
    }
  }
  if (currState == State.run){
    if (currProcess == null){
      try{
        currProcess = Runtime.getRuntime().exec(command);
      } catch(IOException ioe){
        errorMsg = ioe.getMessage();
        currState = State.error;
      }
    }
    if (currProcess != null){
      try{
        int exitVal = currProcess.exitValue();
        if (exitVal == 0){
          currProcess = null;
          currState = State.loadImage;
        } else {
          errorMsg = "running exited with code " + exitVal;
          currState = State.error;
        }
      } catch(IllegalThreadStateException itse){
        //exception gets thrown until process exits
      }
    }
  }
  if (currState == State.loadImage){
    img = loadImage(imageLoc);
    currState = State.display;
  }
  if (currState == State.display){
    image(img, 0, 0);
  }
  if (currState == State.error){
    background(255, 0, 0);
    fill(0);
    text(errorMsg, 10, 20);
    println(errorMsg);
    noLoop();
  }
}