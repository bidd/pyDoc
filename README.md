# pyDoc
Python documentation generator

Based on Flex + Bison + C, pyDoc is a simple tag-based documentation generator for your python code.

#Howto
  '''<br>
  #pydoc<br>
  #Summary<br>
    This is a small, one line comment.<br><br>
  #params<br>
    type1   include a brief description<br>
    type2   include a brief descrption<br><br>
  #summary<br>
    Now you can<br>
    write that long explanation<br>
    of what this function is about<br>
    but you need to close it#<br><br>
  #example<br>
    This is where you teach people how to <br>
    use this function<br>
    but dont forget to close too#<br>
  <br>
  '''<br>
  def hello_world():<br>
