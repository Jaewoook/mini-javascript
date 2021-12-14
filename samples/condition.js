let case_match = '1';

switch ('1') {
    case '1': console.log("aaa");
    case case_match: console.log("is it work?")
    case case_match == 1: console.log("is it work?")
}

if (!is_lower_case(case_match)) {
    case_match = to_upper_case(case_match);
}