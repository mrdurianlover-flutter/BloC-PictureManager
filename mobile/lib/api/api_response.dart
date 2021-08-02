class ApiResponse<T> {
  Status status;
  T? body;
  String? message;

  ApiResponse.loading(this.message) : status = Status.LOADING;
  ApiResponse.completed(this.body) : status = Status.COMPLETED;
  ApiResponse.error(this.message) : status = Status.ERROR;

  @override
  String toString() {
    return "Status : $status \n Message : $message \n Data : $body";
  }
}

enum Status { LOADING, COMPLETED, ERROR }
