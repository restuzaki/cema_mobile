import 'package:get/get.dart';
import '../../../data/repositories/expense_repository.dart';
import '../../../service/authenticated_client.dart';
import '../controllers/add_expense_controller.dart';

class AddExpenseBinding extends Bindings {
  @override
  void dependencies() {
    // Lazily put repository if not already there, or generic dependency injection setup
    // Assuming ProjectRepo is already global or bound elsewhere, but ExpenseRepo might be new.
    // Ideally Repositories are put in initial binding or here.
    // Let's put it here to be safe.
    Get.lazyPut<ExpenseRepository>(
      () => ExpenseRepository(client: Get.find<AuthenticatedClient>()),
    );

    Get.lazyPut<AddExpenseController>(() => AddExpenseController());
  }
}
