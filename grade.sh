CPATH='.:lib/hamcrest-core-1.3.jar:lib/junit-4.13.2.jar'

rm -rf student-submission
rm -rf grading-area

mkdir grading-area

git clone $1 student-submission
echo 'Finished cloning'


# Draw a picture/take notes on the directory structure that's set up after
# getting to this point

# Then, add here code to compile and run, and do any post-processing of the
# tests

if [ -f "student-submission/ListExamples.java" ]; then
    echo "File found!"
else
    echo "ListExamples.java not found!"
    exit 1
fi

# jars
cp -r lib grading-area
# ListExamples
cp student-submission/ListExamples.java grading-area/
# TestListExamples
cp TestListExamples.java grading-area/

cd grading-area
javac -cp $CPATH *.java 2> compileErr.txt

if [ $? -ne 0 ]; then
    echo "Compile error!"
    exit 1
else
    echo "Compiled successfully!"
fi

javac -cp $CPATH TestListExamples.java
java -cp $CPATH org.junit.runner.JUnitCore TestListExamples > testing.txt

if grep -q "Failures:" testing.txt; then
    fail_count=$(grep "Failures:" testing.txt | awk '{print $5}')
    total_count=$(grep "run:" testing.txt | awk -F'[, ]' '{print $3}')
    successes=$((total_count - fail_count))
    echo "Number of errors: $fail_count"
    echo "Total grade: $successes / $total_count"
elif grep -q "OK (" testing.txt; then
    echo "Total grade: 100%"
else
    echo "Fatal Error"
fi
