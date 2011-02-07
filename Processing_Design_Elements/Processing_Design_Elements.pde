/**
 * Copyright (c) 2011, James Boelen
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *     * Redistributions of source code must retain the above copyright
 *       notice, this list of conditions and the following disclaimer.
 *     * Redistributions in binary form must reproduce the above copyright
 *       notice, this list of conditions and the following disclaimer in the
 *       documentation and/or other materials provided with the distribution.
 *     * Neither the name of the James Boelen nor the
 *       names of its contributors may be used to endorse or promote products
 *       derived from this software without specific prior written permission.
 * 
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL JAMES BOELEN BE LIABLE FOR ANY
 * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 **/
 
/**
 * Version 0.1
 **/

/**
 * Variables
 * Below are any variables necissary to make design elemens
 * work properly. Include defaults and other general settings.
 */

//Default values 
int _designElements_defaults_height = 100; // Default height for popup
int _designElements_defaults_width  = 100; // Default width for popup;
int _designElements_defaults_padding = 5;
boolean _designElements_defaults_visibility = true;

//Variables
int _designElements_variables_theta  = 200; //Time between registering keys

PImage _designElements_variables_titlebar_img;
int _designElements_variables_titlebar_height = 20;



//To Do:
//      Default Font
//      Default Font Size
//      Labels

/**
 * Interfaces
 * What follows are the interfaces that all of the main UI 
 * elements are created from. We want to make sure that all of
 * the elements are uniform and this is the best way to achieve 
 * this.
 */
//Main interface for all of the design elements
interface DesignElement {

  void draw();
  boolean mousePressed();
  void mouseDragged();
  void mouseReleased();
  void keyPressed();

  void hide();
  void show();
  boolean getVisibility();

  void setValue(String in);
  String getValue();

  void setWidth(int _width);  
  void setHeight(int _height);
  double getHeight();
  double getWidth();
}

//Allows buttons to interact with design elements
interface Delegate {
  void CallBack();
}


/**
 * Classes
 */
//Design Elements Collection - Mater Class
class DesignElementsCollection {

  ArrayList elements;
  boolean interfere;

  DesignElementsCollection() {
    elements = new ArrayList();
    interfere = false;
  }

  void add(DesignElement element) {
    elements.add(element);
  }

  void draw() {
    for(int i = 0; i < elements.size(); i++)
    {
      ((DesignElement)elements.get(i)).draw();
    }
  }

  boolean mousePressed() {
    interfere = false;
    for(int i = elements.size() - 1; i > -1 && !interfere; i--)
    {
      interfere = ((DesignElement)elements.get(i)).mousePressed();
    }
    return interfere;
  }

  void mouseDragged() {
    for(int i = 0; i < elements.size(); i++)
    {
      ((DesignElement)elements.get(i)).mouseDragged();
    }
  }

  void mouseReleased() {
    for(int i = 0; i < elements.size(); i++)
    {
      ((DesignElement)elements.get(i)).mouseReleased();
    }
  }

  void keyPressed() {
    for(int i = 0; i < elements.size(); i++)
    {
      ((DesignElement)elements.get(i)).keyPressed();
    }
  }
}

//                                    //
// Text Box - Text Box Design Element //
//                                    //
class TextBox implements DesignElement {
  public int x,y,width,height;
  public int fillColor, borderColor, cursorColor;
  public int selectedFillColor, selectedBorderColor;
  public int textColor, selectedTextColor;
  public boolean visible, focus;
  public String value, label;

  private boolean _cursor_visible;
  private int _last_draw, _last_keyCheck;

  TextBox()
  {
    x = 0;
    y = 0;
    width = 0;
    height = 0;
    setDefaults();
  }

  TextBox(int _x, int _y)
  {
    x = _x;
    y = _y;
    width = 150;
    height = 20;
    setDefaults();
  }

  TextBox(int _x, int _y, int _width, int _height) {
    x = _x;
    y = _y;
    width = _width;
    height = _height;
    setDefaults();
  }

  private void setDefaults() {
    value = "";
    visible = true;
    _cursor_visible = false;
    fillColor = selectedFillColor = #FFFFFF;
    borderColor = selectedBorderColor = #000000;
    cursorColor = #000000;
    textColor = selectedTextColor = #000000;
    _last_draw = 0;
    _cursor_visible = false;
  }

  void hide() {
    visible = false;
  }

  void show() {
    visible = true;
  }

  boolean getVisibility()
  {
    return visible;
  }

  void setValue(String _value) {
    value = _value;
  }
  String getValue() {
    return value;
  }

  void setHeight(int _height) {
    height = _height;
  }
  void setWidth(int _width) {
    width = _width;
  }
  double getHeight(){return height;}
  double getWidth(){return width;}

  void draw()
  {
    if(visible) {   
      //set color depending on focus
      if(focus) {
        fill(selectedFillColor);
        stroke(selectedBorderColor);
      }
      else {
        fill(fillColor);
        stroke(borderColor);
      }

      //draw body
      rect(x,y,width,height);

      //draw text
      fill(textColor);
      text(value, x + 5, y + 15);

      //draw cursor;
      if(focus)
      {
        if (millis() - _last_draw > 500)
        {
          _cursor_visible = !_cursor_visible;
          _last_draw = millis();
        }

        if (_cursor_visible) {
          fill(cursorColor);
          text("|", x + 5 + textWidth(value), y + 15);
        }
      }
    }
  }

  boolean mousePressed() {
    if(visible && mouseInside()){
      focus = true;
      return true;
    }else
      focus = false;
    return false;
  }

  //No Events
  void mouseDragged() {
  }

  //No Events
  void mouseReleased() {
  }

  void keyPressed() {
    if (focus && millis() - _last_keyCheck > _designElements_variables_theta) {
      if(keyCode > 31 && keyCode != 157)
        value += key;
      else if (keyCode == 8 && value.length() > 0)
        value = value.substring(0,value.length() - 1);
    }
  }

  private boolean mouseInside() {
    if (mouseX > x && mouseX < x + width)
      if (mouseY > y && mouseY < y + height)
        return true;
    return false;
  }
}

//                                   //
//Checkbox - Checkbox Design Element //
//                                   //
class CheckBox implements DesignElement {
  public int x,y,width,height;
  public int fillColor, borderColor, markColor;
  public int selectedFillColor, selectedBorderColor;
  public int padding;

  public boolean visible;
  public boolean value;
  public String label;

  CheckBox(int _x, int _y) {
    x = _x;
    y = _y;
    setDefaults();
  }

  private void setDefaults()
  {
    width = height = 20;
    fillColor = selectedFillColor = #FFFFFF;
    borderColor = selectedBorderColor = #000000;
    markColor = #000000;
    visible = true;
    value = false;
    padding = 5 ;
  }

  void draw() {
    if(visible) {
      if (value) {
        fill(selectedFillColor);
        stroke(selectedBorderColor);
      }
      else {
        fill(fillColor);
        stroke(borderColor);
      }
      rect(x,y,width,height);
      if (value == true)
      {
        strokeWeight(2);
        line (x + padding, y  + padding, x + width  - padding, y + height  - padding);
        line (x + padding, y + height  - padding, x + width  - padding, y  + padding);
        strokeWeight(1);
      }
    }
  }
  boolean mousePressed() {
    if (mouseInside()){
      value = !value;
      if (value)
        return true;  
    }
    return false;
  }
  void mouseDragged() {
  }
  void mouseReleased() {
  }
  void keyPressed() {
  }

  void hide() { 
    visible = false;
  }
  void show() { 
    visible = true;
  }
  boolean getVisibility() { 
    return visible;
  }

  void setValue(String in) {
    if (in == "true" || in == "t")
      value = true;
    else
      value = false;
  }

  String getValue() { 
    return "" + value;
  }

  void setWidth(int _width) { 
    width = _width;
  }  
  void setHeight(int _height) { 
    height = _height;
  }
  
  double getHeight(){return height;}
    double getWidth(){return width;}

  private boolean mouseInside() {
    if (mouseX > x && mouseX < x + width)
      if (mouseY > y && mouseY < y + height)
        return true;
    return false;
  }
}

//                                          //
//Radiobutton - Radio button Design Element //
//                                          //
class RadioButton implements DesignElement {
  public int x,y,width,height;
  public int fillColor, borderColor, markColor;
  public int selectedFillColor, selectedBorderColor;
  public int padding;

  public boolean visible;
  public boolean value;
  public String label;

  RadioButton(int _x, int _y) {
    x = _x;
    y = _y;
    setDefaults();
  }

  private void setDefaults()
  {
    width = height = 15;
    fillColor = selectedFillColor = #FFFFFF;
    borderColor = selectedBorderColor = #000000;
    markColor = #000000;
    visible = true;
    value = false;
    padding = 5 ;
  }

  void draw() {
    if(visible) {
      if (value) {
        fill(selectedFillColor);
        stroke(selectedBorderColor);
      }
      else {
        fill(fillColor);
        stroke(borderColor);
      }
      ellipse(x + (width / 2),y + (height / 2),width,height);
      if (value == true)
      {
        fill(markColor);
        noStroke();
        ellipse(x + (width / 2), y + (height / 2), width - 5, height - 5);
      }
    }
  }
  boolean mousePressed() {
    if (mouseInside()){
      value = !value;
      if (value)
        return true;
    }
    return false;
  }
  void mouseDragged() {
  }
  void mouseReleased() {
  }
  void keyPressed() {
  }

  void hide() { 
    visible = false;
  }
  void show() { 
    visible = true;
  }
  boolean getVisibility() { 
    return visible;
  }

  void setValue(String in) {
    if (in == "true" || in == "t")
      value = true;
    else
      value = false;
  }

  String getValue() { 
    return "" + value;
  }

  void setWidth(int _width) { 
    width = _width;
  }  
  void setHeight(int _height) { 
    height = _height;
  }
  
  double getHeight(){return height;}
  double getWidth(){return width;}

  private boolean mouseInside() {
    if (mouseX > x && mouseX < x + width)
      if (mouseY > y && mouseY < y + height)
        return true;
    return false;
  }
}

//                                                  //
//SlidingSelector - Sliding Selector Design Element //
//                                                  //
class SlidingSelector implements DesignElement {
  public int x,y,width,height, low, high, steps;
  public int fillColor, borderColor, markColor;
  //public int selectedFillColor, selectedBorderColor;
  public int padding;

  public boolean visible;
  public double value, position;
  public String label;
  
  private int _mouseStart;
  private boolean _focus;
  
  SlidingSelector(int _x, int _y, int _low, int _high, int _steps)
  {
    x = _x;
    y = _y;
    setDefaults();
    low = _low;
    high = _high;
  }

  private void setDefaults() {
    low = 0;
    high = 1;
    width = 100;
    height = 20;
    fillColor = #FFFFFF;
    borderColor = #000000;
    markColor = #000000;
    visible = true;
    value = 50;
    _focus = false;
  }

  void draw() {
    fill(fillColor);
    stroke(borderColor);
    rect(x, y, width + 4, height/3);
    rect(x + 2 + (int)((width - (3 + width / 40)) * value / 100), y - 5, width / 20, 10 + height / 3);
  }
  boolean mousePressed() {
    _mouseStart = mouseX;
    if (mouseInside()){
      _focus = true;
      return true;
    }
    return false;
  }
  void mouseDragged() {
    if (!_focus)
      return;
    int _diff = mouseX - _mouseStart;
    value += _diff;
    if (value < 1)
      value = 0;
    else if (value > 99)
      value = 100;
    _mouseStart = mouseX;
  }
  void mouseReleased() {
    _focus = false;
  }
  void keyPressed() {
  }

  void hide() { 
    visible = false;
  }
  void show() { 
    visible = true;
  }
  boolean getVisibility() { 
    return visible;
  }

  void setValue(String in) {
    //get
  }
  String getValue() {
    return "" + value;
  }

  void setWidth(int _width) { 
    width = _width;
  }  
  void setHeight(int _height) { 
    height = _height;
  }
  
  double getHeight(){return height;}
  double getWidth(){return width;}
  
  private boolean mouseInside() {
    if (mouseX > x && mouseX < x + width)
      if (mouseY > y && mouseY < y + height)
        return true;
    return false;
  }
}

//                               //
//Button - Button Design Element //
//                               //
class Button implements DesignElement {

  public int x,y,width,height;
  public int fillColor, borderColor;
  public int hoverFillColor, hoverBorderColor;
  public int textColor, selectedTextColor;
  public boolean visible, value;
  public String label;
  
  public Delegate delegate;

  Button() {
    x = y = 0;
    setDefaults();
  }

  Button(int _x, int _y, int _width, int _height, String _label)
  {
    setDefaults();
    x = _x;
    y = _y;
    width = _width;
    height = _height;
    label = _label;
  }

  private void setDefaults() {
    width = height = 15;
    fillColor = #FFFFFF;
    hoverFillColor = #AFAFAF;
    borderColor = hoverBorderColor = #000000;
    visible = true;
    value = false;
  }

  void draw() {
    if(visible)
    {
      if (mouseInside())
      {
        fill(hoverFillColor);
        stroke(hoverBorderColor);
      }
      else {
        fill(fillColor);
        stroke(borderColor);
      }
      rect(x,y,width,height);
      stroke(#000000);
      fill(#000000);
      text(label, x + (width - textWidth(label) - 2 ) /2, y + 15);
    }
  }
  boolean mousePressed() {
    if (mouseInside() && delegate != null){
      delegate.CallBack();
      return true;
    }
    return false;
  }
  void mouseDragged() {
  }
  void mouseReleased() {
  }
  void keyPressed() {
  }

  void hide() { 
    visible = false;
  }
  void show() { 
    visible = true;
  }
  boolean getVisibility() { 
    return visible;
  }

  void setValue(String in) {
  }
  String getValue() {
    return "" + value;
  }

  void setWidth(int _width) { 
    width = _width;
  }  
  void setHeight(int _height) { 
    height = _height;
  }
  
  double getHeight(){return height;}
    double getWidth(){return width;}
  
  private boolean mouseInside() {
    if (mouseX > x && mouseX < x + width)
      if (mouseY > y && mouseY < y + height)
        return true;
    return false;
  }
}

//                                     //
//PopUpBox - Pop Up Box Design Element //
//                                     //
class PopUpBox implements DesignElement{
  int x,y, width, height;
  int fillColor, borderColor;
  String title;
  boolean visible;
  DesignElementsCollection collection;
  
  PopUpBox(){
    setDefaults();
    this.add(new Button(x + 10,y + 10,20,20,"Close"));
  }
  
  PopUpBox(int _x, int _y, int _width, int _height){
    setDefaults();
    x = _x;
    y = _y;
    width = 20;
    height = _designElements_defaults_padding + 21;
    Button b = new Button(x + 10,y + height,70,20,"Close");
    b.delegate = new ClosePopUp(this);
    this.add(b);
  }
  
  void add(DesignElement _element){
    height += _element.getHeight() + _designElements_defaults_padding;
    width = (_element.getWidth() > width)? (int)_element.getWidth() + 20 : width;
    this.collection.add(_element);
  }
  
  private void setDefaults(){
    this.collection = new DesignElementsCollection();
    visible = true;
    width = _designElements_defaults_width;
    height = _designElements_defaults_height;
    fillColor = #FFFFFF;
    borderColor = #000000;
    title = "Demo";
  }
  
  void draw(){
    if(visible){
      fill(fillColor);
      stroke(borderColor);
      rect(x, y, width, height);
      image(_designElements_variables_titlebar_img, x+ 1, y + 1, width - 1, 21);
      fill(#000000);
      text(title, x + (width - textWidth(title) - 2 ) /2, y + 15);
      this.collection.draw();
    }
  }
  boolean mousePressed(){
    if(visible && (this.collection.mousePressed() || mouseInside()))
      return true; 
    return false;
  }
  void mouseDragged(){
    if(visible)
      this.collection.mouseDragged();
  }
  void mouseReleased(){
    if(visible)
      this.collection.mouseReleased();
  }
  void keyPressed(){
    if(visible)
      this.collection.keyPressed();
  }
  
  void hide() { 
    visible = false;
  }
  void show() { 
    visible = true;
  }
  boolean getVisibility() { 
    return visible;
  }
  
  void setValue(String _value){
    
  }
  
  String getValue() {
    return "" + visible;
  }

  void setWidth(int _width) { 
    width = _width;
  }  
  void setHeight(int _height) { 
    height = _height;
  }
  
  double getHeight(){return height;}
    double getWidth(){return width;}
  
  private boolean mouseInside() {
    if (mouseX > x && mouseX < x + width)
      if (mouseY > y && mouseY < y + height)
        return true;
    return false;
  }
  
  private class ClosePopUp implements Delegate{
    PopUpBox p;
    ClosePopUp(PopUpBox _p){ p = _p; }
    void CallBack(){
      p.visible = false;
    }
  }

}



/**
 * Test Application
 * This is a short application that test the functionality and
 * demonstrates the use of Processing Design Elements.
 */
DesignElementsCollection collection;
TextBox tbTest;
CheckBox cbTest;

class SampleButtonEvent implements Delegate
{
  Button b;  
  SampleButtonEvent(Button _b){
    b = _b;
  }
  void CallBack(){
    b.fillColor = #FF0000;
  }
}

void setup()
{
  _designElements_variables_titlebar_img = loadImage("resources/bar_bg.png");
  size(200,300);
  collection = new DesignElementsCollection();

  collection.add(new TextBox(10,10,150,20));
  tbTest = new TextBox(10, 40, 150, 20);
  tbTest.selectedFillColor = #FF9999;

  collection.add(new CheckBox (10, 70));
  cbTest = new CheckBox(10, 100);
  cbTest.selectedFillColor = #99FF99;
  collection.add(cbTest);

  collection.add(new RadioButton(10, 130));

  collection.add(new SlidingSelector(10, 160, 0, 1, 10));

  Button b = new Button(10, 190, 150, 20, "Turn Red");
  b.delegate = new SampleButtonEvent(b);
  collection.add(b);
  collection.add(new PopUpBox(10,10,100,100));
}

/** Mouse Input **/
void mousePressed() {
  if(!collection.mousePressed())
    tbTest.mousePressed();
  
}

void mouseDragged() {
  collection.mouseDragged();
}

void mouseReleased() {
  collection.mouseReleased();
}

/** Keyboard Input **/
void keyPressed() {
  collection.keyPressed();
  tbTest.keyPressed();
}

/** Processing Entry Point **/
void draw() {
  background(#FFFFFF);
  tbTest.draw();
  collection.draw();
}
