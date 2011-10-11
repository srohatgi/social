import java.util.ArrayList;

interface Iterator {
  boolean hasNext();
  Object next();
}

class Collection {
  ArrayList arr_;
  public Collection(ArrayList arr) {
    arr_ = arr;
  }

  public Iterator iterator() {
    return new DeepIterator(arr_);
  }
}

class C1 {
  String v_;
  public C1(String v) { v_ = v; }
  public String toString() { return v_; }
}

public class DeepIterator implements Iterator {
  java.util.Iterator i_;
  ArrayList arr_;
  java.util.Stack<java.util.Iterator> stack_;

  public DeepIterator(java.util.ArrayList arr) {
    arr_ = arr;
    i_ = arr_.iterator();
    stack_ = new java.util.Stack<java.util.Iterator>();
  }

  public boolean hasNext() {
    if ( i_.hasNext() ) return true;
    if ( stack_.isEmpty()!=true ) {
      i_ = stack_.pop();
      return hasNext();
    }
    return false;
  }

  public Object next() {
    Object o = i_.next();
    if ( o instanceof ArrayList ) {
      stack_.push(i_);
      i_ = ((ArrayList)o).iterator();
      o = next();
    }
    return o;
  }

  public static void main(String[] args) {
    try {
      ArrayList<Object> arr = new ArrayList<Object>();
      ArrayList<Object> elt1 = new ArrayList<Object>();
      ArrayList<Object> elt2 = new ArrayList<Object>();
  
      arr.add(new C1("A"));
      arr.add(new C1("B"));
        elt1.add(new C1("C"));
        elt1.add(new C1("D"));
          elt2.add(new C1("E"));
        elt1.add(elt2);
        elt1.add(new C1("F"));
      arr.add(elt1);
      arr.add(new C1("G"));

      System.out.println(arr);

      Collection c = new Collection(arr);
      Iterator i = c.iterator();
      while (i.hasNext()) {
        System.out.println("element:"+i.next());
      }
      
    } catch (Exception e) {
      e.printStackTrace();
    }
  }
}
