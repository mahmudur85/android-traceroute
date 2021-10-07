%module(directors = "1") traceroutelib

//
// Suppress few warnings
//
#pragma SWIG nowarn=312

%{
#include "traceroutelib.h"

using namespace std;
%}

%{
#include <stdexcept>
#include "jni.h"
#include "android/log.h"

#ifdef SWIGJAVA
extern JavaVM *jni_jvm;

static JNIEnv *JNU_GetEnv() {
    JNIEnv *env;
    jint rc = jni_jvm->GetEnv((void **) &env, JNI_VERSION_1_4);
    if (rc == JNI_EDETACHED)
        throw std::runtime_error("current thread not attached");
    if (rc == JNI_EVERSION)
        throw std::runtime_error("jni version not supported");
    return env;
}
#endif

%}

// Constants from libraries
//%include "symbols.i"

//
// STL stuff.
//
%include "std_string.i"
%include "std_vector.i"

%template(StringVector) std::vector<std::string>;
%template(IntVector) std::vector<int>;

namespace std {
        %template(VecDouble) vector<double>;
}

#ifdef SWIGJAVA
%include "enumtypeunsafe.swg"
%javaconst(1);

%pragma(java) jniclasscode=%{
  static {
    try {
	    System.loadLibrary("traceroute");
    } catch (UnsatisfiedLinkError e) {
	    System.err.println("Failed to load native library 'traceroutelib'\n" + e);
    }
  }
%}
#endif


#ifdef SWIGJAVA
// byte array
%typemap(jtype) (signed char *data, int length) "byte[]"
%typemap(jstype) (signed char *data, int length) "byte[]"
%typemap(jni) (signed char *data, int length) "jbyteArray"
%typemap(javadirectorin) (signed char *data, int length) "$jniinput"
%typemap(javadirectorout) (signed char *data, int length) "$javacall"
%typemap(javain) (signed char *data, int length) "$javainput"
%typemap(in,numinputs=1) (signed char *data, int length) {
  // Note the NULL here if you don't want to be making changes visible
  $1 = JCALL2(GetByteArrayElements, jenv, $input, NULL);
  $2 = JCALL1(GetArrayLength, jenv, $input);
}
%typemap(freearg) (signed char *data, int length) {
  // Or use  0 instead of ABORT to keep changes if it was a copy
  if ($input) JCALL3(ReleaseByteArrayElements, jenv, $input, $1, JNI_ABORT);
}
%typemap(directorin, descriptor="[B", noblock=1) (signed char *data, int length) {
  $input = 0;
  if ($1) {
    $input = JCALL1(NewByteArray, jenv, (jsize)$2);
    if (!$input) return $null;
    JCALL4(SetByteArrayRegion, jenv, $input, 0, (jsize)$2, (jbyte *)$1);
  }
  Swig::LocalRefGuard $1_refguard(jenv, $input);
}
%typemap(directorargout, noblock=1) (signed char *data, int length){
  if ($input && $1){
    JCALL4(GetByteArrayRegion, jenv, $input, 0, (jsize)$2, (jbyte *)$1);
  }
}
%typemap(directorout) (signed char *data, int length) {
  $1 = 0;
  if($input){
		$result = JCALL2(GetByteArrayElements, jenv, $input, NULL);
		if(!$1)
			return $null;
    JCALL3(ReleaseByteArrayElements, jenv, $input, $result, 0);
	}
}
#endif

//#ifdef SWIGJAVA
///* This tells SWIG to treat char ** as a special case when used as a parameter
//   in a function call */
//%typemap(in) char ** (jint size) {
//  int i = 0;
//  size = (*jenv)->GetArrayLength(jenv, $input);
//  $1 = (char **) malloc((size+1)*sizeof(char *));
//  /* make a copy of each string */
//  for (i = 0; i<size; i++) {
//    jstring j_string = (jstring)(*jenv)->GetObjectArrayElement(jenv, $input, i);
//    const char * c_string = (*jenv)->GetStringUTFChars(jenv, j_string, 0);
//    $1[i] = malloc((strlen(c_string)+1)*sizeof(char));
//    strcpy($1[i], c_string);
//    (*jenv)->ReleaseStringUTFChars(jenv, j_string, c_string);
//    (*jenv)->DeleteLocalRef(jenv, j_string);
//  }
//  $1[i] = 0;
//}
//
///* This cleans up the memory we malloc'd before the function call */
//%typemap(freearg) char ** {
//  int i;
//  for (i=0; i<size$argnum-1; i++)
//    free($1[i]);
//  free($1);
//}
//
///* This allows a C function to return a char ** as a Java String array */
//%typemap(out) char ** {
//  int i;
//  int len=0;
//  jstring temp_string;
//  const jclass clazz = (*jenv)->FindClass(jenv, "java/lang/String");
//
//  while ($1[len]) len++;
//  jresult = (*jenv)->NewObjectArray(jenv, len, clazz, NULL);
//  /* exception checking omitted */
//
//  for (i=0; i<len; i++) {
//    temp_string = (*jenv)->NewStringUTF(jenv, *result++);
//    (*jenv)->SetObjectArrayElement(jenv, jresult, i, temp_string);
//    (*jenv)->DeleteLocalRef(jenv, temp_string);
//  }
//}
//
///* These 3 typemaps tell SWIG what JNI and Java types to use */
//%typemap(jni) char ** "jobjectArray"
//%typemap(jtype) char ** "String[]"
//%typemap(jstype) char ** "String[]"
//
///* These 2 typemaps handle the conversion of the jtype to jstype typemap type
//   and vice versa */
//%typemap(javain) char ** "$javainput"
//%typemap(javaout) char ** {
//    return $jnicall;
//  }
//
///* Now a few test functions */
//%inline %{
//
//int print_args(char **argv) {
//  int i = 0;
//  while (argv[i]) {
//    printf("argv[%d] = %s\n", i, argv[i]);
//    i++;
//  }
//  return i;
//}
//
//char **get_args() {
//  static char *values[] = { "Dave", "Mike", "Susan", "John", "Michelle", 0};
//  return &values[0];
//}
//
//%}
//#endif

%feature("director");

/* Let's just grab the original header file here */
%include "traceroutelib.h"