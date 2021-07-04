import 'package:cloudbase_auth/cloudbase_auth.dart';
import 'package:cloudbase_function/cloudbase_function.dart';
import 'package:cloudbase_storage/cloudbase_storage.dart';
import 'package:cloudbase_database/cloudbase_database.dart';
import 'package:cloudbase_core/cloudbase_core.dart';

CloudBaseCore core = CloudBaseCore.init({
  'env': 'cain-4g2138ye969ed21d',
  'appAccess': {
    'key': '7b6f087506f295e08c53955c277cba35',
    'version': '1'
  }
});
CloudBaseAuth auth = CloudBaseAuth(core);
CloudBaseDatabase db = CloudBaseDatabase(core);
CloudBaseStorage storage = CloudBaseStorage(core);
CloudBaseFunction cloudbase = CloudBaseFunction(core);
