/// Reports violations as JUnit XML.
public struct JUnitReporter: Reporter {
    // MARK: - Reporter Conformance

    public static let identifier = "junit"
    public static let isRealtime = false

    public var description: String {
        return "Reports violations as JUnit XML."
    }

    public static func generateReport(_ violations: [StyleViolation]) -> String {
        """
        <?xml version="1.0" encoding="utf-8"?>
        <testsuites>
            <testsuite>
        \(violations.map({ violation -> String in
            let location = violation.location
            let fileName = (location.relativeFile ?? "<nopath>").escapedForXML()
            let severity = violation.severity.rawValue
            let lineNumber = String(location.line ?? 0)
            let reason = violation.reason.escapedForXML()
            return """
                    <testcase classname='Formatting Test' name='\(fileName)\'>
                        <failure message='\(reason)\'>\(severity):
            Line:\(lineNumber) </failure>
                    </testcase>
            """
        }).joined(separator: "\n"))
            </testsuite>
        </testsuites>

        """
    }
}
