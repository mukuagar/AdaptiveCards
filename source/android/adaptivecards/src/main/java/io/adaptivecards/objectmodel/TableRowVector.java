/* ----------------------------------------------------------------------------
 * This file was automatically generated by SWIG (http://www.swig.org).
 * Version 4.0.2
 *
 * Do not make changes to this file unless you know what you are doing--modify
 * the SWIG interface file instead.
 * ----------------------------------------------------------------------------- */

package io.adaptivecards.objectmodel;

public class TableRowVector extends java.util.AbstractList<TableRow> implements java.util.RandomAccess {
  private transient long swigCPtr;
  protected transient boolean swigCMemOwn;

  protected TableRowVector(long cPtr, boolean cMemoryOwn) {
    swigCMemOwn = cMemoryOwn;
    swigCPtr = cPtr;
  }

  protected static long getCPtr(TableRowVector obj) {
    return (obj == null) ? 0 : obj.swigCPtr;
  }

  @SuppressWarnings("deprecation")
  protected void finalize() {
    delete();
  }

  public synchronized void delete() {
    if (swigCPtr != 0) {
      if (swigCMemOwn) {
        swigCMemOwn = false;
        AdaptiveCardObjectModelJNI.delete_TableRowVector(swigCPtr);
      }
      swigCPtr = 0;
    }
  }

  public TableRowVector(TableRow[] initialElements) {
    this();
    reserve(initialElements.length);

    for (TableRow element : initialElements) {
      add(element);
    }
  }

  public TableRowVector(Iterable<TableRow> initialElements) {
    this();
    for (TableRow element : initialElements) {
      add(element);
    }
  }

  public TableRow get(int index) {
    return doGet(index);
  }

  public TableRow set(int index, TableRow e) {
    return doSet(index, e);
  }

  public boolean add(TableRow e) {
    modCount++;
    doAdd(e);
    return true;
  }

  public void add(int index, TableRow e) {
    modCount++;
    doAdd(index, e);
  }

  public TableRow remove(int index) {
    modCount++;
    return doRemove(index);
  }

  protected void removeRange(int fromIndex, int toIndex) {
    modCount++;
    doRemoveRange(fromIndex, toIndex);
  }

  public int size() {
    return doSize();
  }

  public TableRowVector() {
    this(AdaptiveCardObjectModelJNI.new_TableRowVector__SWIG_0(), true);
  }

  public TableRowVector(TableRowVector other) {
    this(AdaptiveCardObjectModelJNI.new_TableRowVector__SWIG_1(TableRowVector.getCPtr(other), other), true);
  }

  public long capacity() {
    return AdaptiveCardObjectModelJNI.TableRowVector_capacity(swigCPtr, this);
  }

  public void reserve(long n) {
    AdaptiveCardObjectModelJNI.TableRowVector_reserve(swigCPtr, this, n);
  }

  public boolean isEmpty() {
    return AdaptiveCardObjectModelJNI.TableRowVector_isEmpty(swigCPtr, this);
  }

  public void clear() {
    AdaptiveCardObjectModelJNI.TableRowVector_clear(swigCPtr, this);
  }

  public TableRowVector(int count, TableRow value) {
    this(AdaptiveCardObjectModelJNI.new_TableRowVector__SWIG_2(count, TableRow.getCPtr(value), value), true);
  }

  private int doSize() {
    return AdaptiveCardObjectModelJNI.TableRowVector_doSize(swigCPtr, this);
  }

  private void doAdd(TableRow x) {
    AdaptiveCardObjectModelJNI.TableRowVector_doAdd__SWIG_0(swigCPtr, this, TableRow.getCPtr(x), x);
  }

  private void doAdd(int index, TableRow x) {
    AdaptiveCardObjectModelJNI.TableRowVector_doAdd__SWIG_1(swigCPtr, this, index, TableRow.getCPtr(x), x);
  }

  private TableRow doRemove(int index) {
    long cPtr = AdaptiveCardObjectModelJNI.TableRowVector_doRemove(swigCPtr, this, index);
    return (cPtr == 0) ? null : new TableRow(cPtr, true);
  }

  private TableRow doGet(int index) {
    long cPtr = AdaptiveCardObjectModelJNI.TableRowVector_doGet(swigCPtr, this, index);
    return (cPtr == 0) ? null : new TableRow(cPtr, true);
  }

  private TableRow doSet(int index, TableRow val) {
    long cPtr = AdaptiveCardObjectModelJNI.TableRowVector_doSet(swigCPtr, this, index, TableRow.getCPtr(val), val);
    return (cPtr == 0) ? null : new TableRow(cPtr, true);
  }

  private void doRemoveRange(int fromIndex, int toIndex) {
    AdaptiveCardObjectModelJNI.TableRowVector_doRemoveRange(swigCPtr, this, fromIndex, toIndex);
  }

}