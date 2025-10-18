%{
#include "CSP/Systems/Maintenance/Maintenance.h"
%}

//Temporary declaration of a simple method to prove linking works in dependent projects
namespace csp {
    namespace systems {
        class MaintenanceInfo {
        public:
            bool IsInsideWindow() const;
        };
    }
}