import Foundation
import Testing
@testable import VehicleCompanion

struct VehicleFormModelTests {
    @Test
    func formValidationRequiresNicknameMakeModelAndValidYear() {
        var form = VehicleFormModel()
        form.nickname = ""
        form.make = ""
        form.model = ""
        form.year = 2024

        #expect(form.isValid == false)

        form.nickname = "Daily"
        form.make = "Toyota"
        form.model = "Corolla"
        form.year = 1800

        #expect(form.isValid == false)

        form.year = 2024
        #expect(form.isValid == true)
    }

    @Test
    func toVehicleTrimsFields() {
        var form = VehicleFormModel()
        form.nickname = "  Daily Car  "
        form.make = "  Toyota "
        form.model = " Corolla  "
        form.vin = "  VIN123 "
        form.year = 2022

        let vehicle = form.toVehicle(existingID: nil)

        #expect(vehicle.nickname == "Daily Car")
        #expect(vehicle.make == "Toyota")
        #expect(vehicle.model == "Corolla")
        #expect(vehicle.vin == "VIN123")
    }
}
